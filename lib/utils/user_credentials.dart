late String userRole;
late String userName;
late String userID;
late String classcode;

void saveUserRole(String user){
  userRole = user;
}

String getUserRole(){
  return userRole;
}

void saveUserName(String user){
  userName = user;
}

String getUserName(){
  return userName;
}

void saveUserID(String id){
  userID = id;
}

String getUserID(){
  return userID;
}

void saveClasscode(String code){
  classcode = code;
}

String getClasscode(){
  return classcode;
}