class Product{

  String productCategory, productId, productName, imageUrl;
  int productPrice, productQuantity;

  Product({this.productCategory, this.productId, this.productName, this.productPrice, this.productQuantity, this.imageUrl});

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['productCategory'] = this.productCategory;
    map['productId'] = this.productId;
    map['productName'] = this.productName;
    map['productPrice'] = this.productPrice;
    map['productQuantity'] = this.productQuantity;
    map['imageUrl'] = this.imageUrl;
    return map;
  }

}