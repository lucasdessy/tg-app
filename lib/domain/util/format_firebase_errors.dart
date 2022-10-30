String formatFirebaseErrors(String code) {
  String? message;

  switch (code) {
    case 'invalid-email':
      message = 'E-mail ou senha inválidos';
      break;
    case 'wrong-password':
      message = 'E-mail ou senha inválidos';
      break;
    case 'user-not-found':
      message = 'Usuário não encontrado';
      break;
    case 'email-already-in-use':
      message = 'E-mail já em uso';
      break;
    case 'user-disabled':
      message = 'Usuário desabilitado';
      break;
    case 'missing-email':
      message = 'E-mail não informado';
      break;
    case 'weak-password':
      message = 'Senha fraca';
      break;
  }

  return message ?? 'Ocorreu um erro desconhecido';
}
