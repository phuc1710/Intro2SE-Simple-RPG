class User {
  String username = '';
  String password = '';
  bool isAdmin = false;
  bool isMod = false;
  String creationDate = DateTime.now().toString();

  fromData(data) {
    this.username = data['username'];
    this.password = data['password'];
    this.isAdmin = data['isAdmin'];
    this.isAdmin = data['isAdmin'];
    this.creationDate = data['creationDate'];
  }

  toData() {
    return {
      'username': this.username,
      'password': this.password,
      'isAdmin': this.isAdmin,
      'isMod': this.isAdmin,
      'creationDate': this.creationDate,
    };
  }

  save(dbRef) {
    dbRef.child('users').push().set(toData());
  }
}
