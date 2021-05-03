import 'dart:convert';

import 'package:formularios/src/models/producto_model.dart';
import 'package:formularios/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';

class ProductosProvider {
  //Firebase
  final String _url = 'https://flutter-fa164-default-rtdb.firebaseio.com';
  //Preferencias de Usuario
  final prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto) async {
    //URL peticion
    final url =
        "https://flutter-fa164-default-rtdb.firebaseio.com/productos.json?auth=${prefs.token}";
    //Peticion HTTP
    final resp =
        await http.post(Uri.parse(url), body: productoModelToJson(producto));
    final decodedData = json.decode(resp.body);
    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final Uri url = Uri.parse(
        "https://flutter-fa164-default-rtdb.firebaseio.com/productos/${producto.id}.json?auth=${prefs.token}");
    //Reemplazo con put
    final resp = await http.put(url, body: productoModelToJson(producto));
    final decodedData = json.decode(resp.body);
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final Uri url = Uri.parse(
        "https://flutter-fa164-default-rtdb.firebaseio.com/productos.json?auth=${prefs.token}");
    final resp = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = new List();
    if (decodedData == null) return [];
    if (decodedData['error'] != null) return [];

    decodedData.forEach((id, producto) {
      final productoTemp = ProductoModel.fromJson(producto);
      productoTemp.id = id;
      productos.add(productoTemp);
    });
    return productos;
  }

  Future<int> borrarProducto(String id) async {
    final Uri url = Uri.parse(
        "https://flutter-fa164-default-rtdb.firebaseio.com/productos/$id.json?auth=${prefs.token}");
    final resp = await http.delete(url);
    return 1;
  }

  Future<String> subirImagen(PickedFile imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/drfam109v/image/upload?upload_preset=hm0hkhul');
    //Tipo de imagen
    final mimeType = mime(imagen.path).split('/'); //image/jpeg
    //REQUEST
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    //Subir archivo
    imageUploadRequest.files.add(file);
    //Ejecutar la peticion
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }
    final respData = json.decode(resp.body);
    return respData['secure_url'];
  }
}
