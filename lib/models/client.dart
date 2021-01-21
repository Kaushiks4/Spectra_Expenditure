class Client {
  String name, phone, address;
  Client({this.name, this.phone, this.address});
  Client.select({this.phone, this.name});
}
