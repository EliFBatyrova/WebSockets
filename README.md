# WebSockets

## Домашнее задание

Дописать чат, который начали делать на паре. Должны быть реализованы и отражены в UI все методы из документации ниже. 
UI должен быть понятен, его реализация на ваше усмотрение. 

## Сервер

Скачать серверную часть нужно отсюда: https://github.com/appcoda/SocketIOChat/blob/master/srv-SocketChat.zip

Чтобы завести сервер, понадобится скачать Node.js, выбирайте стабильную версию отсюда: https://nodejs.org/en/

Чтобы запустить сервер, необходимо ввести команду в терминале: node index.js 

## Документация к серверу

1. Подключиться к чату

Event name: "connectUser"
Parameters: String (clientNickname)

2. Отключиться от чата

Event name: "exitUser"
Parameters: String (clientNickname)

3. Отправить сообщение

Event name: "chatMessage"
Parameters: String, String (clientNickname, message)

4. Получить список собеседников

Event name: "userList"
Ответ: [[[ id: String,
		  nickname: String,
		  isConnected: Bool ]]]

5. Получить новое сообщение

Event name: "newChatMessage"
Ответ: [0: String
		1: String,
		2: String]

6. Сообщить о том, что пользователь начал печатать

Event name: "startType"
Parameters: String (clientNickname)

7. Сообщить о том, что пользователь закончил печатать

Event name: "stopType"
Parameters: String (clientNickname)

