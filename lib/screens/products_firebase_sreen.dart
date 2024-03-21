import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pmsn2024/services/products_firebase.dart';

class ProductsFirebaseScreen extends StatefulWidget {
  const ProductsFirebaseScreen({super.key});

  @override
  State<ProductsFirebaseScreen> createState() => _ProductsFirebaseScreenState();
}

class _ProductsFirebaseScreenState extends State<ProductsFirebaseScreen> {
  final productsFirebase = ProductsFirebase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.store),
        onPressed: () => showModal(context)
      ),
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: StreamBuilder(
        stream: productsFirebase.consultar(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Image.network(snapshot.data!.docs[index].get('imagen'));
              },
            );
          } else {
            if (snapshot.hasError) {
              return Text('Error');
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        },
      ),
    );
  }
  showModal(context){
    
    final conNombre = TextEditingController();
    final conCantidad = TextEditingController();
    final conFecha = TextEditingController();

    final txtNombre = TextFormField(
      keyboardType: TextInputType.text,
      controller: conNombre,
      decoration: const InputDecoration(
        border: OutlineInputBorder()
      ),
    );

    final txtCantidad = TextFormField(
      keyboardType: TextInputType.number,
      controller: conCantidad,
      decoration: const InputDecoration(
        border: OutlineInputBorder()
      ),
    );

    final btnAgregar = ElevatedButton.icon(
      onPressed: (){
        productsFirebase.insertar({
          'cantidad': conCantidad.text,
          'fecha_caducidad': conFecha.text,
          'imagen': 'https://i5.walmartimages.com/asr/35348b01-cb88-4704-898c-9202b3fafd0d_1.bd67301bf5d9ced120e1011e1e21307b.jpeg',
          'nombre_producto': conNombre.text,
        });
      }, 
      icon: Icon(Icons.save), 
      label: Text('Guardar')
    );

    final space = SizedBox(height: 10,);

    final txtFecha = TextFormField(
      controller: conFecha,
      keyboardType: TextInputType.none,
      decoration: const InputDecoration(
        border: OutlineInputBorder()
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(), //get today's date
            firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101)
        );

        if(pickedDate != null ){
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
            setState(() {
                conFecha.text = formattedDate; //set foratted date to TextField value. 
            });
        }else{
            print("Date is not selected");
        }
      },
    );

    
    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return ListView(
          padding: EdgeInsets.all(10),
          children: [
            txtNombre,
            space,
            txtCantidad,
            space,
            txtFecha,
            space,
            btnAgregar
          ],
        );
      },
    );
  }
}
