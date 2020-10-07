class Memory {
  String title, imageUrl;

  Memory({this.title, this.imageUrl});

  Map<String, dynamic> memoryModelToMap() {
    return {"title": this.title, "imageUrl": this.imageUrl};
  }
}
