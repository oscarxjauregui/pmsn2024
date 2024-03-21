class ProductosModel {
  int? idProducto;
  String? nomProducto;
  int? canProducto;
  String? fechaCaducidad;

  ProductosModel({
    this.idProducto,
    this.nomProducto,
    this.canProducto,
    this.fechaCaducidad});
  
  factory ProductosModel.fromMap(Map<String,dynamic> producto){
    return ProductosModel(
      idProducto: producto['idProducto'],
      nomProducto: producto['nomProducto'],
      canProducto: producto['canProducto'],
      fechaCaducidad: producto['fechaCaducidad']
    );
  }

}