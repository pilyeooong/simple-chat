# Simple chat

### 사용 기술
- Ruby (3.3.0)
- Ruby On Rails (7.1.3)
- MongoDB (6.0.16)
- Redis (7.2.4)
- Sidekiq
- Action cable

### 설명
채팅방 기능을 위한 백엔드 서버입니다. Ruby On Rails, MongoDB를 사용하였고, 채팅방 목록, 채팅방 내부에서 사용이 될 API와 웹 소켓이 구현되어 있습니다.
API의 경우 REST 기반으로 작성이 되었고, 웹 소켓의 경우 Action cable을 활용하여 구현하였습니다.
그 외에 background job 및 스케줄링에 대해서는 Sidekiq, Sidekiq scheduler를 활용하였습니다.

### 실행 방법
해당 프로젝트 실행을 위해서는 위에 명시 되있거나 호환 가능한 버전의 Ruby, MongoDB, Redis 설치가 선행 되어야 합니다.

- `git clone https://github.com/pilyeooong/simple-chat.git`
- `bundle install`
  - 프로젝트 실행에 필요한 의존성 및 라이브러리들을 설치합니다.
- `db:mongoid:create_indexes`
  - MongoDB 인덱스를 추가합니다
- `rake db:seed`
  - 테스트를 위한 시드 데이터를 추가합니다.
  - 유저, 채팅방의 경우 10개씩 생성이 되며, 각각의 id는 "1"부터 "10"까지 string 타입으로 할당 되어 있습니다.
- `bundle exec sidekiq`
- `rails s`

## API docs

### # 채팅방 목록
**Endpoint**: /chat_rooms

**Method**: GET

**Request query parameters**
- page (optional)
  - ex) 1
- limit (optional)
  - ex) 30

**Request example**
```http request
GET http://localhost:3000/chat_rooms?page=1&limit=30
```

### # 채팅방 생성
**Endpoint**: /chat_rooms

**Method**: POST

**Request body**
```json
{
    "user_id": 1,
    "name": "test name",
    "description": "test description",
}
```

**Request example**
```http request
POST http://localhost:3000/chat_rooms
```

### # 채팅방 디테일
**Endpoint**: /chat_rooms/1

**Method**: GET

**Request example**
```http request
GET http://localhost:3000/chat_rooms/1
```

### # 채팅방 입장
**Endpoint**: /chat_rooms/1/participate

**Method**: POST

**Request body**
```json
{
    "user_id": 1,
}
```

**Request example**
```http request
POST http://localhost:3000/chat_rooms/1/participate
```

### # 채팅 메시지 조회
**Endpoint**: /chat_rooms/1/messages

**Method**: GET

**Request query parameters**
- time_cursor (optional)
  - 값이 없는 경우 최신 메시지를 조회합니다
  - 값이 있는 경우 전달한 값 이전에 생성된 메시지들을 불러옵니다.
    - ex) "2024-08-23T04:18:18.962Z"
- limit (optional)
  - ex) 10

**Request example**
```http request
GET http://localhost:3000/chat_rooms/1/messages?limit=2&time_cursor=2024-08-23T04:18:18.962Z
```

### # 채팅 메시지 발송
**Endpoint**: /chat_rooms/1/messages

**Method**: POST

**Request body**
```json
{
    "user_id": 1,
    "content": "message"
}
```

**Request example**
```http request
POST http://localhost:3000/chat_rooms/1/messages
```


<br/>

---

## WS docs
웹소켓의 경우 Rails에 내장되어있는 Action cable을 활용하여 구현하였습니다.

**Websocket URL**: `ws://localhost:3000/cable`

### # 채팅방 목록

**Method**: Websocket

**Request example**
```json
{
  "command": "subscribe",
  "identifier": "{\"channel\":\"ChatRoomListChannel\"}"
}
```
**Response example**
```json
{
  "identifier": "{\"channel\":\"ChatRoomListChannel\"}",
  "message": {
    "chat_room": {
      "_id": "2",
      "active_participants_count": 1,
      "admin_id": "2",
      "created_at": "2024-08-23T03:33:49.227Z",
      "deleted_at": null,
      "description": "test2",
      "latest_chat_message": {
        "_id": "66c814dfd15550ab91a5bc6e",
        "chat_room_id": "2",
        "content": "안녕하세요",
        "created_at": "2024-08-23T04:49:35.350Z",
        "deleted_at": null,
        "updated_at": "2024-08-23T04:49:35.350Z",
        "user_id": "2"
      },
      "name": "test2",
      "total_participants_count": 1,
      "updated_at": "2024-08-23T04:49:35.367Z"
    }
  }
}
```

### # 채팅방 입장 시

**Method**: WebSocket

**Request query parameters**
- chat_room_id 

**Request example**
```json
{
  "command": "subscribe",
  "identifier": "{\"channel\":\"ChatRoomChannel\", \"chat_room_id\":\"66c6b9eeca93a4e6ee27383e\"}"
}
```

**Response example**
```json
{
  "identifier": "{\"channel\":\"ChatRoomChannel\", \"chat_room_id\":\"1\"}",
  "message": {
    "chat_message": {
      "_id": "66c812dad15550ab91a5bc69",
      "chat_room_id": "1",
      "content": "d2891001010dd",
      "created_at": "2024-08-23T04:40:58.503Z",
      "deleted_at": null,
      "updated_at": "2024-08-23T04:40:58.503Z",
      "user_id": "1",
      "user": {
        "_id": "1",
        "created_at": "2024-08-23T03:33:49.015Z",
        "deleted_at": null,
        "email": "test1@gmail.com",
        "nickname": "test1",
        "updated_at": "2024-08-23T03:33:49.015Z"
      }
    }
  }
}
```

