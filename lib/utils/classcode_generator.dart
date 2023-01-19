import 'dart:math';

// function to generate an 8-digit classcode
String generateClasscode() {
  var seed = new Random.secure();  // Use a cryptographically secure random number generator
  var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  var code = '';
  for (var i = 0; i < 8; i++) {
    code += characters[seed.nextInt(characters.length)];
  }
  return code;
}