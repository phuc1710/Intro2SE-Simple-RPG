class User {
  String username = '';
  String password = '';

  save(dbRef) {
    dbRef
        .child('users')
        .push()
        .set({'username': username, 'password': password});
  }
}
