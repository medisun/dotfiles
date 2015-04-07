#!/usr/bin/php -qCdshort_open_tag=1
<?php
/**
 * api: cli
 * type: application
 * title: php tag tidying
 * description: rewrites PHP scripts' short/long open tags, close tags, apply whitespace fixes
 * version: 1.0
 * license: public domain
 * author: mario <mario#include-once:org>
 * category: utilities
 * config: <file type="array" value="$HOME/.config/php/phptags.php" title="configuration defaults file" description="an ordinary return(array(...)); script to set interna options like regex=>1 or verbose=>1" />
 * url: http://freecode.com/projects/phptags
 * 
 *
 * Rewrites PHP <?php open tags into long and short forms,
 * or adds and removes the closing ?> or just probes or removes
 * trailing whitespace, or hidden markers (e.g. UTF-8 BOM).
 *
 * A simple invokation that rewrites all *.php? scripts in a given
 * directory (recursively) is:
 *
 *     phptags --whitespace --close  ./forum/
 *
 * It also works on a list of files however:
 *
 *     phptags --warn -v  *.php
 *
 *
 * It currently uses regular expressions for all the whitespace
 * detection and removal tasks. That much is reliable. So --white
 * and --warn options, as well as --close and --unclose rewrites
 * can be safely utilized.
 *
 * Rewriting short and long tags should be done with the tokenizer,
 * which is not completely finished yet. There is some ambiguity
 * with regex for this purpose. Literal <? or closing tags in PHP
 * string context could be affected. 
 * Therefore --long and --short tag rewriting options should not be
 * used habitually, but only when needed prior deployment.
 *
 * Lastly this tool is Public Domain, compatible to all open
 * source and Free software licenses. Thus redistributable with
 * applications, scripts and libraries. BUT COMES WITH NO WARRANTY.
 *
 *
 * @package phptags
 * @license http://creativecommons.org/licenses/publicdomain/
 */


/**
 * Fetch commandline options for later use.
 * Also merges in the configuration file overrides, if present
 *
 */
$action = new ArrayObject(
    (array)@(include(current(array_filter(array("$_SERVER[PHPTAGS_CONFIG]","$_SERVER[XDG_CONFIG_HOME]/php/phptags.php","$_SERVER[HOME]/.config/php/phptags.php","$_SERVER[APPDATA]/php/phptags.php"),"file_exists"))))
    +
    array(
        "help" => argv("-h", "-help", "--help", "/?", "-?"),
        "syntax" => count($_SERVER["argv"]) < 2,
        "long" => argv("-l", "-long", "--long", "--long-open"),
        "php54" => argv("-54", "-php54", "--php54"),      # don't rewrite <?= for PHP 5.4
        "short" => argv("-s", "-short", "--short", "--short-open"),
        "shortall" => argv("-a", "-all", "--all", "-shortall", "--shortall", "--short-all", "-sa"),
        "unclosed" => argv("-u", "-unclosed", "--unclosed", "--remove-closing", "--unclose", "--open", "--opened"),
        "close" => argv("-c", "-close", "--close", "-closed", "--closed", "--add-closing"),
        "white" => argv("-w", "-white", "--white", "--whitespace", "-ws", "--ws", "-space", "--space", "--fix-whitespace", "--bom"),
        "warn" => argv("-W", "-warn", "--warn", "--warning"),
        "recursive" => true + argv("-r"),        # doing that anyway
        "regex" => argv("--regex", "--rx", "-rx"),   # use regex
        "token" => argv("--tokenizer", "--token", "-t"),# use tokenizer
        "color" => argv("-c", "--color", "--ansi") or isset($_SERVER["TERM"]),    # colorize some output
        "quiet" => argv("--quiet", "-quiet", "-q"),
        "verbose" => argv("--verbose", "-verbose", "-v"),
        "debug" => argv("--debug", "-D"),
        "dry" => argv("--dry", "-d"),            # dry run, don't save files
        "new" => argv("--new", "--suffix"),      # save files under file.php.new
        "backup" => argv("-b", "--backup"),      # renames to file.php~ before overwriting
        "version" => argv("--version", "-V"),
        "PCRE_VERSION" => PCRE_VERSION,
        "files" => argv_files(),
   ), 2
);


// show options
($action->debug) and print_r($action);

// print version
($action->version) and print(join(preg_grep('/^\s*\*\s*version+:/', file($_SERVER["argv"][0]))));

// print help
if ($action->help) {
    print <<<HELP
syntax: phptags [options] [path/files]
Traverses a given directory or files to rewrite PHP script tags.

   -l  --long      Convert every short <? into long <?php open tags.
   -s  --short     Shorten small <?php areas into <?= or <? short tags.
   -a  --all       Shorten *all* long tags into short tags.
   -u  --unclosed  Strip closing ?> php tags. (You should prefer --whitespace fixing.)
   -c  --close     Add trailing ?> close tags.
   -w  --white     Fix whitespaces after ?> close tags, or UTF-8 BOM before opening <?php tag.
   -W  --warn      Just warn about whitespace issues.
   -t  --token     Use tokenizer for --short and --long conversion. (Much safer than --regex mode, but doesn't preserve whitespace as well.)
   -h  --help      This very helpful help text \n\n
HELP;
}

// no commandline options were given, so print a short help
elseif ($action->syntax) {
    print "\nexample: phptags --short --close --whitespace  ./dir/ or *.php\nSee also --help\n\n";
}

// were any files specified?
elseif (!$action->files) {
    print "No files or directories specified.\n";
}

// do something, do something!
elseif ($action->long || $action->short || $action->shortall || $action->close || $action->unclosed || $action->white || $action->warn || $action->dry) {
    foreach (files($action->files, $action->recursive) as $I=>$fn) {

        // read in file
        $src = file_get_contents($fn);
        $chksum = md5($src);
        $action->debug and print("$fn: reading [$chksum]\n");


        // whitespace warnings
        if ($action->warn) {
            preg_test("/\?\>([\s\pZ\\0]+)\z/", $src, "TRAILING whitespace");

            # /\\xEF\\xBB\\xBF/ == /\x{FEFF}/u  - But the dependency on a valid UTF-8 encoding can damage binaryish files
            preg_test("/^\\xEF\\xBB\\xBF[\s\pZ]*<\?(php|\W)/i", $src, "UTF-8 BOM before <?php")
            or preg_test("/^\\xEF\\xBB\\xBF/", $src, "UTF-8 BOM alone");

            preg_test("/^[\s\\0]+<\?(php|\W)/i", $src, "Whitespace BEFORE <?php")
            or preg_test("/^[\pZ\s\\0]+<\?(php|\W)/i", $src, "Unicode whitespace BEFORE <?php");
 
            // Consecutive PHP tags which *currently* do not output whitespace
            if ($action->verbose and preg_match("/^\<\?/", $src))
            preg_test("/\?\>(?!\\n<)\s+<\?/", $src, "Consecutive open+close tags with spacing (template?)")
            or preg_test("/\?\>\\r?\\n\<\?/", $src, "Consecutive open+close tags with harmless linebreak");

            // Warn about ambigious PHP tags like `<?print(123)`
            preg_test("/[\s\pZ]+\<\?((?!php|=|xml[-\s]|\w+:\w+)\w++)/i", $src, "Ambiguous PHP tag or unknown XML PI");
        }


        // remove whitespace
        if ($action->white) {
            // spaces after ? >
            preg_modify("/(\?\>)[\s\pZ\\0]+(\z)/", "$1$2", $src, "Removed trailing whitespace");
            // UTF-8 BOM before < ? - but retains spaces until next rule
            preg_modify("/^\\xEF\\xBB\\xBF([\s\pZ\\0]*<\?)(php|\W)/i", "$1$2", $src, "Removed leading UTF-8 BOM");
            // spaces before < ?
            preg_modify("/^[\s\pZ\\0]+(<\?)(php|\W)/i", "$1$2", $src, "Removed leading whitespace");
        }


        // check if we have at least one opening tag
        if (preg_match("/\<\?/", $src)) {
        // (the regex approach is good enough for close tag removal/adding

            // add missing close tags
            if ($action->close) {
                preg_modify("/
                    \<\?            # any opening tag
                    (?!.*\?\>).+    # filler, assert no '?>' close tags in between 
                    [\s\pZ]* \z     # whitespace, and end of file
                    /sx",
                    "$0\?\>", $src, "Added ?> close tag"
                );
            }

            // remove any close tags
            if ($action->unclosed) {
                preg_modify("/
                    \?\>          # close tag
                    [\s\pZ]* \z   # whitespace before end of file (gets removed too, but not if NUL bytes)
                    /sx",
                    "", $src, "Removed ?> close tag"
                );
            }
        }


        // Tokenize source for easier processing.
        if ($action->token && !$action->regex) {
            // only usable (for this purpose) if php-cli.ini hasn't short open tags disabled
            ini_get("short_open_tag") or exit("TokenizerCannotBeUsedAsShortTagsAreStillDisabled");;
            defined("T_OPEN_TAG_WITH_ECHO") or exit("OhGodNoTokenizerIsNotAvailable");;
            /*
               The long T_OPEN_TAG always includes some space "<?php\s",
               but consecutive/others are split into a separate token.
               While the short versions are followed by a distinct
               T_WHITESPACE or maybe completely absent.
               Therefore multiple alternatives are required for each test.
            */
            $token = new token_list($src);

            // add long tags
            if ($action->long) {
                $token->modify(
                    array(T_OPEN_TAG, "<?", T_WHITESPACE),
                    array("<?php"),
                    "Convert open tag into long tag, preserve space"
                );
                $token->modify(
                    array(T_OPEN_TAG, "<?"),
                    array("<?php "),
                    "Convert open tag into long tag, add space"
                );
                if (!$action->php54) {
                    $token->modify(
                        array(T_OPEN_TAG_WITH_ECHO, "<?=", T_WHITESPACE),
                        array("<?php echo"),
                        "Convert short echo (+space) into long tag"
                    );
                    $token->modify(
                        array(T_OPEN_TAG_WITH_ECHO),
                        array("<?php echo "),
                        "Convert short <?= into long <?php␣echo tag"
                    );
                }
            }

            // convert echo tags into <?=
            if ($action->short or $action->shortall) {  //@todo we should actually have a set of T_PRINTs here too, equivality w/& regex mode
                $token->modify(
                    array(T_OPEN_TAG, array("/\<\?php\s/i"), T_ECHO),
                    array("<?=", ""),  // Does not preserve whitespace separator
                    "Convert long <?php␣echo tag into short <?= tag"
                );
                $token->modify(
                    array(T_OPEN_TAG, array("/\<\?php\s/i"), T_WHITESPACE, T_ECHO),
                    array("<?=", "", ""),  // Does not preserve extra whitespace
                    "Convert long long <?php␣echo tag into short <?= tag"
                );
            }

            // rewrite all remaining long tags
            if ($action->shortall) {
                $token->modify(  // replaces <?php_ with short tag, regex retains any first not-space whitespace character (the lookbehind asserts the space before, but doesn't capture it for $retainspaces= replacement)
                    array(T_OPEN_TAG, array("/^\<\?php ?((?<=\\x20)|\s|\R)$/i")),
                    array("<?"),
                    "Convert long tag into short tag",
                    $retainspace=0
                );
            }

            // assemble back
            $src = $token->merge();
        }


	// Nah, let's just use regex for this.
        // This could trip over "<?" and "\?\>" occurences within PHP comments or in string context etc.
        else {


            // convert short into long tags
            if ($action->long && !$action->php54) {
                preg_modify(  
                    "/\<\?= ?(\R|\s)?/",
                    "\<\?php echo $1",
                    $src,
                    "Convert <?=␣ into long <?php␣echo tag"
                );
            }
            if ($action->long) {
                preg_modify(
                    array("/\<\?((?!php)\S)/i", "/\<\?(\s)/"),
                    array("\<\?php $1",         "\<\?php$1"),
                    $src,
                    "Convert <?␣ into long <?php␣ tag"
                );
            }


            // convert long into short tags
            if ($action->short || $action->shortall) {
                preg_modify( //retain leading newline          // use trailing linebreak            // no linebreak, no output spacing
                     array("/\<\?php(\R\s*)(echo|print)(\s)/", "/\<\?php(\s+)(echo|print)(\R\s*)/", "/\<\?php(\s+)(echo|print)(\s)/"),
                     array("\<\?=$1",                          "\<\?=$3",                           "\<\?="),
                     $src,
                     "Long <?php␣echo to short <?="
                );
                preg_modify( // look for single-line <?php ... ? > occurences, those should always be shortened
                    "/ (?<!^)       # not at the file begin
                       \<\?php      # opening \<\?php
                       (\s+.+\?\>)  # space, filler, closing \?\>
                    /x",
                    "\<\?$1",
                    $src,
                    "Single line <?php...?> into short tag"
                );
            }

            // even the initial open tag and longer sections
            if ($action->shortall) {
                preg_modify( // look for mixed syntax '<? echo', strip any initial spacing type
                    "/\<\?(\s*)(echo|print)\b/", "\<\?=",
                    $src,
                    "Mixed <?␣echo to short <?="
                );
                preg_modify(
                    // keep space character after <?php, do not allow any non-space separate alternative expressions (e.g. <?php( or <?php/ would actually be short tag plus php() function call or an expression const/division).
                    "/\<\?php(\R|\s)/", "\<\?$1",
                    $src,
                    "Any <?php␣ into short tag"
                );
            }
        }



        // write back if file was changed
        if ($chksum !== md5($src) && strlen($src)) {
            if ($action->backup) {
                rename($fn, "$fn~");
            }
            elseif ($action->new) {
                $fn .= ".new";
            }
            if ($action->dry) {
                print("$fn: Unsaved changes (--dry)\n");
            }
            else {
                file_put_contents($fn, $src) and print("$fn: Changed and saved\n");
            }
        }
   }
}

// no recognized option
else {
    echo "No action flag (-w or -c, -l etc) specified. (See --help.)\n";
}





#-- utility code --


/**
 * Checks for option presence in ARGV.
 *
 * @param+ string
 */
function argv() {
    $args = func_get_args();
    return count(array_intersect($_SERVER["argv"], $args));
}

/**
 * Return all ARGs without leading - hyphen.
 *
 */
function argv_files() {
    return preg_grep('/^[^-]/', array_slice($_SERVER["argv"], 1));
}


/**
 * Convert list of filespecs (dirs or file.* names) into iterator list.
 *
 * @return iterator
 */
function files($list, $recursive=1) {
    foreach ($list as &$fn) {
        $fn = is_dir($fn) && $recursive /*should actually mask the recdiriterator below*/
            ? new RegexIterator(new RecursiveIteratorIterator(new RecursiveDirectoryIterator($fn)), '/\.(php[345]?|phtml)$/')
            : new ArrayIterator(file_exists($fn) ? array($fn) : glob($fn));
    }
    //@bug: https://bugs.php.net/bug.php?id=49104
    $l = new AppendIterator();
    $l->append($workaround = new ArrayIterator(array(1)));  foreach ($list as $i) { if ($i) { $l->append($i); } }  unset($workaround[0]);
    return($l);
}



#-- regex --


/**
 * Test with regex, return result and print message if matched.
 *
 */
function preg_test($regex, $src, $message) {
    return preg_match($regex, $src, $m) and message($message, '"'.nonprint_visualize($m[0]).'"', 1);
}


/**
 * Modify source string with regex, print message if anything changed.
 *
 */
function preg_modify($regex, $replace, &$src, $message) {
    $replace = is_array($replace) ? array_map("stripslashes", $replace): stripslashes($replace);  // for parity with the regex, the replacement string contains extraneous backslashes
    $tmp = preg_replace($regex, $replace, $src, -1, $changed);

    // assert that the regex succeeded, and didn't return a failure status instead
    if ($tmp === NULL) {
        trigger_error("preg_modify regex failure: '" . strtr($regex, "\n", " ") . "'", E_USER_ERROR);
    }
    // if succesful
    elseif (is_string($tmp) && ($src != $tmp)) {
        $src = $tmp;
        message($message, $changed);
    }
}


/**
 * Print out current activity. If --verbose enabled.
 *
 */
function message($message, $count, $nq=FALSE) {

    global $fn, $action; /* oh no, how evil. that's the tipping point that will make this completely unmaintainable.. */

    if ($count and ($action->verbose or $nq and !$action->quiet)) {
        print "$fn: $message ($count)\n";
    }
    return 1;
}


/**
 * Colorize control + non-printable characters and/or replace with C-string escapes.
 *
 */
function nonprint_visualize($str) {
    global $action;
    $map = $action->color ? array(
        "\r" => "\x1b[32m\\r\x1b[39m",
        "\n" => "\x1b[31m\\n\x1b[39m",
        "\t" => "\x1b[36m\\t\x1b[39m",
        " "  => "\x1b[34m\\x20\x1b[39m",
        "\\0" => "\x1b[41;1;33m\\0\x1b[0;39m",
        "\\"  => "\x1b[35m\\\\\x1b[39m",
        "\xEF\xBB\xBF" => "\x1b[4;1;36m\\xEF\\xBB\\xBF\x1b[0;39m",
    ) : array();
    return preg_replace("~\\xEF\\xBB\\xBF|[^\w-.,;:#*+´`\'\"!§$%&/()={}?<>|]~e",
           "isset(\$map['$0']) ? \$map['$0'] : '\\x'.strtoupper(current(unpack('H*','$0')))", $str);
}



#-- tokenizer --


/**
 * Simple token list traversal.
 *
 */
class token_list extends ArrayObject {

    /**
     * Call tokenizer for initialization. Simplify token stream.
     */
    function __construct($src) {
        parent::__construct( token_get_all($src) );

        // chop off the line numbers, turn raw string entries into arrays
        foreach ($this as $i=>$t) {
            $this[$i] = is_array($t) ? array($t[0], $t[1]) : array(T_CHARACTER, $t);
        }
    }

    /**
     * Just merge all token parts / raw strings.
     */
    function merge($src = "") {
        return join(array_map("end", $this->getArrayCopy() ));
    }

    /**
     * Traverse token list and replace found things.
     *
     * @param array      Token types or strings to search for (where each entry: int=T_TOKEN, str="literal", array=regex; the list must always alternate with an integer token type to advance the search pointer)
     * @param array      Replacement token string(s)
     * @param string     Activity/success message to print out
     */
    function modify($from, $to, $message, $retainspace=NULL, $count=0) {

        // loop over token list ($this==array)
        foreach ($this as $i=>$t) {

            if (($t[0] == $from[0])          // compare main token type
            and $this->compare_list($i, $from) )  // additional tokens/strings
            {
                // add replacement strings
                $this->overwrite($i, (array)$to, $retainspace);
                $count++;
            }
        }
        message($message, $count);
    }

    /**
     * Compares a series of T_TYPES, strings, or against a regex (=if param is wrapped as array).
     */
    function compare_list($i, $tokens) {
        $this->captured = NULL;

    	foreach ($tokens as $x=>$find) {

            // get value to compare against according to type (string / T_TOKEN int)
            $cmp = $this[$i][is_int($find) ? 0 : 1];
            
            // exact match
    	    if (is_scalar($find) and ($cmp == $find)) {
    	       /* keep comparing */
    	    }
    	    elseif (is_array($find) and preg_match(current($find), $cmp, $this->captured)) {
    	       /* keep comparing */
    	    }
            else {
               return false;  //
            }

            // move in token stream if next search entry is a T_TYPE
    	    $i += isset($tokens[$x+1]) && is_int($tokens[$x+1]);
    	}
    	return true;
    }
    
    /**
     * Overwrite entries in token stream with list of strings. (Or NULL where to skip.)
     */
    function overwrite($i, $with, $patch) {

        // piggyback the last regex-captured space characters back into one of the replacement strings; usually it gets appended to the first $to[0] overwrite string
        if (is_int($patch) && $this->captured[1]) { 
            $with[$patch] = preg_replace("/ ?$/", $this->captured[1], $with[$patch]);
        }

        // overwrite string entries
        foreach ($with as $new_code) if (is_string($new_code)) {
            $this[$i++] = array(T_INLINE_HTML, $new_code);
        } else { $i++; }
    }

}



// OH LOOK! A close tag!
?>