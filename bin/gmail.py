import poplib, email
 
server = "pop.yandex.ru"
port = "995"
login = "mail@server.com" 
password = "paaaaaaaaass"


print('')
box = poplib.POP3_SSL(server, port)
# в принципе, если порт 110, то его можно и не указывать
# если вам нужно подключаться с использованием SSL, то потребуется питон не ниже 2.6 и выглядеть это будет так:
# box = poplib.POP3_SSL(server, port) # в принципе, если порт 995, то его можно и не указывать
 
box.user(login)
box.pass_(password)
 
response, lst, octets = box.list()
print "DEBUG: Total %s messages: %s" % (login, len(lst))
 
for msgnum, msgsize in [i.split() for i in lst]:
    (resp, lines, octets) = box.retr(msgnum)
    msgtext = "n".join(lines) + "nn"
    message = email.message_from_string(msgtext) # если надо, парсим письмо и получаем объект со всеми данными
    # print message["to"]
    print message["subject"]
    # print(msgtext)
    # box.dele(msgnum) # если надо - удаляем с сервера письмо
    # реально оно будет удалено только после закрытия ящика,
    # а эта функция производит пометку письма как удалённого
    # и пока ящик не закрыт, письмо можно восстановить
 
box.quit()
