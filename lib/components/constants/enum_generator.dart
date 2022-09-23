enum StatusMediaType { textActivity, imageActivity }

enum ChatMessageType {
  none,
  image,
  audio,
  document,
  video,
  text
}

enum ImageProviderCategory { fileImage, exactAssetImage, networkImage }

enum ConnectionStateName { connect, pending, accept, connected }

enum ConnectionStateType { buttonNameWidget, 
buttonNameOnly,
buttonBorderColor }

enum OtherConnectionStatus {
  // ignore: constant_identifier_names
  request_pending,
  // ignore: constant_identifier_names
  request_accepted,
  // ignore: constant_identifier_names
  invitation_came,
  // ignore: constant_identifier_names
  invitation_accepted,
  
}

 enum MessageHolderType{
   me,
   connectedUsers
 }

enum PreviousMessageColTypes {
  actualMessage,
  messageDate,
  messageTime,
  messageHolder,
  messageType,
}


enum PlayerState {
  playing,
  paused,
  stopped,
}

enum Gender {
  male,
  female,
}
