class Logger {
  final String name;
  bool mute = false;

  // _cache is library-private, thanks to
  // the _ in front of its name.
  static final Map<String, Logger> _cache = <String, Logger>{};

  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._internal(name));
  }

  factory Logger.fromJson(Map<String, Object> json) {
    print("imprimindo: ${json['name'].toString()}");
    return Logger(json['name'].toString());
  }

  Logger._internal(this.name){
    print("novo objeto");
  }

  void log(String msg) {
    if (!mute) print(msg);
  }
}

void main(){
  var logger = Logger('UI');
  logger.log('Button clicked');

  var logMap = {'name': 'UI'};
  var loggerJson = Logger.fromJson(logMap);
  loggerJson.mute = true;
  loggerJson.log('Button clicked again');
}