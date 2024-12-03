abstract class Things<V> {
  V? getByName(String name);
  void setByName(String name, V value);
}

class ThingsMap<V> extends Things<V> {
  final Map<String, V> _storage = {};

  @override
  V? getByName(String name) {
    return _storage[name];
  }

  @override
  void setByName(String name, V value) {
    _storage[name] = value;
  }
}

void main() {
  Things<String> stringThings = ThingsMap<String>();
  stringThings.setByName("name", "Alice");
  stringThings.setByName("city", "Wonderland");
  print("Name: " + stringThings.getByName("name")!); // Alice
  print("City: " + stringThings.getByName("city")!); // Wonderland
}
