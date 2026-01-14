# Step 2: Add Database for Persistence

[← Previous Step](../1/README.md) | [Next Step →](../3/README.md)

**Estimated Time**: 25 minutes

## 🎯 Goal
Store rooms and messages in database with ActiveRecord.

## 📝 Tasks

### 1. Install gems

```bash
gem install activerecord sqlite3
```

### 2. Create database config (config/database.rb)

```ruby
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'chat_app.db'
)
```

### 3. Create Room model (lib/models/room.rb)

```ruby
class Room < ActiveRecord::Base
  has_many :messages, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
```

### 4. Create Message model (lib/models/message.rb)

```ruby
class Message < ActiveRecord::Base
  belongs_to :room

  validates :username, presence: true
  validates :content, presence: true

  def as_json(options = {})
    {
      id: id,
      username: username,
      content: content,
      timestamp: created_at.strftime('%H:%M')
    }
  end
end
```

### 5. Create tables (db/migrate.rb)

```ruby
require_relative '../config/database'

ActiveRecord::Base.connection.create_table :rooms, force: true do |t|
  t.string :name, null: false
  t.timestamps
end

ActiveRecord::Base.connection.add_index :rooms, :name, unique: true

ActiveRecord::Base.connection.create_table :messages, force: true do |t|
  t.string :username, null: false
  t.text :content, null: false
  t.references :room, foreign_key: true
  t.timestamps
end

# Seed rooms
require_relative '../lib/models/room'
Room.create(name: 'general')
Room.create(name: 'random')
Room.create(name: 'tech')

puts "✓ Database created and seeded"
```

### 6. Run migration

```bash
ruby db/migrate.rb
```

### 7. Update app.rb

```ruby
require 'sinatra'
require_relative 'config/database'
require_relative 'lib/models/room'
require_relative 'lib/models/message'

get '/' do
  redirect '/rooms'
end

get '/rooms' do
  @rooms = Room.all
  erb :rooms
end

get '/room/:name' do
  @room = Room.find_by(name: params[:name])
  halt 404, "Room not found" unless @room
  @messages = @room.messages.order(:created_at).limit(50)
  erb :chat
end

# API endpoint to get messages
get '/api/rooms/:name/messages' do
  content_type :json
  room = Room.find_by(name: params[:name])
  halt 404 unless room

  messages = room.messages.order(:created_at).limit(50)
  messages.map(&:as_json).to_json
end
```

### 8. Update rooms view to use database

Replace `views/rooms.erb`:
```erb
<h2>Chat Rooms</h2>

<div class="rooms-list">
  <% @rooms.each do |room| %>
    <div class="room-card">
      <h3><%= room.name.capitalize %></h3>
      <p class="room-info"><%= room.messages.count %> messages</p>
      <a href="/room/<%= room.name %>" class="btn">Enter Room</a>
    </div>
  <% end %>
</div>
```

Add to CSS:
```css
.room-info {
  color: #666;
  font-size: 0.875rem;
  margin-bottom: 1rem;
}
```

## ✅ Checkpoint

Run the lab:
```bash
make sinatra-lab NUM=4
```

Test:
- [ ] Database file (chat_app.db) is created
- [ ] Three rooms are seeded
- [ ] Can view rooms list from database
- [ ] API endpoint returns JSON messages
- [ ] Room message count displays

Test API in browser or curl:
```bash
curl http://localhost:4567/api/rooms/general/messages
```

## 💡 What You Learned

- Setting up ActiveRecord with SQLite
- Creating models with associations (has_many, belongs_to)
- Database migrations and seeding
- Creating JSON API endpoints
- Custom serialization with as_json
- Database-driven views

## 🎯 Tips

- `as_json` customizes how models convert to JSON
- Foreign keys automatically manage relationships
- `dependent: :destroy` cascades deletions
- Always validate presence of critical fields
- Limit message queries to prevent performance issues

---

[← Previous Step](../1/README.md) | [Next Step →](../3/README.md)
