class ChatUser {
  final int id;
  final String name;

  ChatUser({
    this.id,
    this.name,
  });
}

// YOU - current user
final ChatUser currentUser = ChatUser(
  id: 0,
  name: 'Nick Fury',
);

// USERS
final ChatUser ironMan = ChatUser(
  id: 1,
  name: 'Iron Man',
);
final ChatUser captainAmerica = ChatUser(
  id: 2,
  name: 'Captain America',
);
/*
final User hulk = User(
  id: 3,
  name: 'Hulk',
);
final User scarletWitch = User(
  id: 4,
  name: 'Scarlet Witch',
);
final User spiderMan = User(
  id: 5,
  name: 'Spider Man',
);
final User blackWindow = User(
  id: 6,
  name: 'Black Widow',
);
final User thor = User(
  id: 7,
  name: 'Thor',
);
final User captainMarvel = User(
  id: 8,
  name: 'Captain Marvel',
);*/