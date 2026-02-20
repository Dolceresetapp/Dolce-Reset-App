// ignore_for_file: constant_identifier_names

final class ResponseMessage {
  ResponseMessage._();
  // API response messages
  static const String SUCCESS = "Operazione riuscita";
  static const String NO_CONTENT = "Operazione riuscita senza contenuto";
  static const String BAD_REQUEST = "Richiesta non valida. Riprova più tardi";
  static const String UNAUTORISED = "Utente non autorizzato. Riprova più tardi";
  static const String FORBIDDEN = "Richiesta vietata. Riprova più tardi";
  static const String INTERNAL_SERVER_ERROR =
      "Qualcosa è andato storto. Riprova più tardi";
  static const String NOT_FOUND = "URL non trovato. Riprova più tardi";

  // Local status codes
  static const String CONNECT_TIMEOUT = "Tempo scaduto. Riprova più tardi";
  static const String CANCEL = "Richiesta annullata";
  static const String RECIEVE_TIMEOUT = "Tempo scaduto. Riprova più tardi";
  static const String SEND_TIMEOUT = "Tempo scaduto. Riprova più tardi";
  static const String CACHE_ERROR = "Errore di cache. Riprova più tardi";
  static const String NO_INTERNET_CONNECTION = "Controlla la tua connessione internet";
  static const String DEFAULT = "Qualcosa è andato storto";

  // Add more descriptive comments or documentation as needed
}

final class ResponseCode {
  ResponseCode._();
  static const int SUCCESS = 200; // success with data
  static const int NO_CONTENT = 201; // success with no data (no content)
  static const int BAD_REQUEST = 400; // failure, API rejected request
  static const int UNAUTORISED = 401; // failure, user is not authorised
  static const int FORBIDDEN = 403; //  failure, API rejected request
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side
  static const int NOT_FOUND = 404; // failure, not found

  // local status code
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}
