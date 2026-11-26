import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para los inputFormatters del teléfono
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp( MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Formulario()
    );
  }
}


// -------------------------------------------------------------
// 1ª PANTALLA
// -------------------------------------------------------------

class Formulario extends StatefulWidget {
  Formulario ({super.key});

  @override
  State<Formulario> createState() => FormularioState();
}


class FormularioState extends State<Formulario> {
  //CONTROLADORES
  final nombreController = TextEditingController();
  final apellidosController = TextEditingController();
  final telefonoController = TextEditingController();
  final fechaNacimientoController = TextEditingController();
  final correoController = TextEditingController();
  final contrasenaController = TextEditingController();
  final confirmaContrasenaController = TextEditingController();

  //MENSAJES DE ERROR
  String? errorNombre;
  String? errorApellidos;
  String? errorTelefono;
  String? errorFecha;
  String? errorPais;
  String? errorCorreo;
  String? errorContra;
  String? errorConfContra;
  String? errorTerminos;

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
  );

  //Guarda la opcion seleccionada
  String? opcionSeleccionada;
  //Lista con las opciones disponibles
  final List<String> opciones = ['España', 'Francia', 'Portugal', 'Italia'];

  bool seleccionado = false;
  bool obscureText = true;
  bool obscureText2 = true;


  // MÉTODO DISPOSE: Fundamental para liberar memoria de los controladores
  @override
  void dispose() {
    nombreController.dispose();
    apellidosController.dispose();
    correoController.dispose();
    telefonoController.dispose();
    fechaNacimientoController.dispose();
    contrasenaController.dispose();
    confirmaContrasenaController.dispose();
    super.dispose();
  }


  void limpiarCampos (){
    nombreController.text = "";
    apellidosController.text = "";
    correoController.text = "";
    telefonoController.text = "";
    fechaNacimientoController.text = "";
    contrasenaController.text = "";
    confirmaContrasenaController.text = "";
    opcionSeleccionada = null;
    seleccionado = false;

    // Al limpiar, también reseteamos los errores visuales
    errorNombre = null;
    errorApellidos = null;
    errorCorreo = null;
    errorTelefono = null;
    errorFecha = null;
    errorContra = null;
    errorConfContra = null;
    errorPais = null;
    errorTerminos = null;

    opcionSeleccionada = null;
    seleccionado = false;
  }

  void validarFormulario (){
    setState(() {
      //1. Validar el nombre
      if( nombreController.text.isEmpty){
        errorNombre = "El nombre es obligatorio";
      } else {
        errorNombre = null;
      }

      //2. Validar apellidos
      if ( apellidosController.text.isEmpty){
        errorApellidos = "Los apellidos son obligatorios";
      } else{
        errorApellidos = null;
      }

      //3. Validar el correo
      if ( correoController.text.isEmpty) {
        errorCorreo = "El correo es obligatorio";
      } else if (!emailRegex.hasMatch(correoController.text)){
        errorCorreo = "Formato de correo invalido";
      } else {
        errorCorreo = null;
      }

      //4. Validar Telefono
      if (telefonoController.text.isEmpty){
        errorTelefono = "El número de teléfono es obligatorio";
      } else if (telefonoController.text.length != 9){
        errorTelefono = "El número de teléfono debe tener 9 numeros";
      } else {
        errorTelefono = null;
      }

      //5. Fecha de Nacimiento
      if ( fechaNacimientoController.text.isEmpty){
        errorFecha = "La fecha de naciemiento es obligatoria";
      } else{
        errorFecha = null;
      }

      //6. Contraseña
      if ( contrasenaController.text.isEmpty){
        errorContra = "La contraseña es obligatoria";
      } else{
        errorContra = null;
      }

      //7. Confirmacion Contraseña
      if (confirmaContrasenaController.text.isEmpty){
        errorConfContra = "La confirmación de contraseña es obligatoria";
      } else if (confirmaContrasenaController.text != contrasenaController.text){
        errorConfContra = "La confirmacion de contraseña debe ser igual a la contraseña";
      } else {
        errorConfContra = null;
      }

      //8. Confirmacion de pais
      if ( opcionSeleccionada == null){
        errorPais = "Debe seleccionar un país";
      }
      else {
        errorPais = null;
      }

      //9. Confirmacion de terminos
      if ( seleccionado == false){
        errorTerminos = "Debe aceptar los terminos";
      }
      else {
        errorTerminos = null;
      }
    });

    if (errorNombre == null && errorApellidos == null && errorCorreo == null && errorTelefono  == null && errorFecha  == null &&
      errorContra  == null && errorConfContra == null && errorPais  == null && errorTerminos  == null)
      {
      //CUADRO DE DIALOGO CON EL RESUMEN DE LOS DATOS
      mostrarResumen();
    }
  }

  //CUADRO DE DIALOGO CON EL RESUMEN DE LOS DATOS
  void mostrarResumen() {
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green,),
              SizedBox(width: 10),
              Text("Registro Exitoso"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, //Para que el cuadro no ocupe toda la pantalla
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nombre: ${nombreController.text} ${apellidosController.text}"),
              Text("Correo: ${correoController.text}"),
              Text("Teléfono: ${telefonoController.text}"),
              Text("Fecha: ${fechaNacimientoController.text}"),
              Text("País: $opcionSeleccionada"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                setState(() {
                  limpiarCampos(); // Limpia el formulario tras el éxito
                });
              },
              child: const Text("Aceptar"),
            )
          ],
        );
      }
    );
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Registro de Usuario",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // -------------------------------------------------------------
              // SECCIÓN 1: DATOS PERSONALES
              // -------------------------------------------------------------
            Card(
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Datos Personales",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 20,),

                  TextField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      labelText: "Nombre *",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      errorText: errorNombre,
                      prefixIcon: Icon(Icons.person_outlined)
                    ),
                    
                  ),

                  SizedBox(height: 20,),

                  TextField(
                    controller: apellidosController,
                    decoration: InputDecoration(
                      labelText: "Apellidos *",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      errorText: errorApellidos,
                      prefixIcon: Icon(Icons.badge_outlined)
                    ),
                  ),

                  SizedBox(height: 20,),

                  TextField(
                    controller: telefonoController,
                    keyboardType: TextInputType.number, //Al seleccionar este campo se abre el teclado numerico
                    maxLength: 9, //Para que solo pueda escribir un maximo de 9 caracteres
                    decoration: InputDecoration(
                      labelText: "Numero de telefono *",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      errorText: errorTelefono,
                      prefixIcon: Icon(Icons.phone_outlined)
                    ),
                  ),

                  SizedBox(height: 20,),

                  TextField(
                    controller: fechaNacimientoController,

                    //TODO ESTO HACE QUE SE ABRA EL CALENDARIO DE GOOGLE
                    readOnly: true, // Evita que se escriba texto a mano
                    onTap: () async {
                      // Abre el cuadro de diálogo del calendario
                      DateTime? fechaSeleccionada = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1940),
                        lastDate: DateTime.now(),
                      );
                      // Si el usuario eligió una fecha, la escribimos en el controlador
                      if (fechaSeleccionada != null) {
                        setState(() {
                          fechaNacimientoController.text =
                              "${fechaSeleccionada.day}/${fechaSeleccionada.month}/${fechaSeleccionada.year}";
                        });
                      }
                    },

                    decoration: InputDecoration(
                      labelText: "Fecha de Nacimiento *",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      errorText: errorFecha,
                      prefixIcon: Icon(Icons.date_range_outlined)
                    ),
                  ),

                  SizedBox(height: 20,),

                  DropdownButtonFormField<String>(
                    value: opcionSeleccionada,  //Muestra la opcion actual seleccionada
                    hint: Text('Selecciona un pais'),  //Texto que sale cuando no hay nada seleccionado
                    isExpanded: true,  //Para que ocupe todo el ancho del contenedor
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_city),
                      errorText: errorPais,
                    ),

                    //Convierte cada String de la lista en un widget
                    items: opciones.map((String opcion) {
                      return DropdownMenuItem<String>(
                        value: opcion,
                        child: Text(opcion),
                      );
                    }).toList(), 

                    //Se ejecuta cuando el usuario pulsa una accion
                    onChanged: (String? nuevoValor){
                      setState(() {
                        opcionSeleccionada = nuevoValor;
                      });
                    }
                  ),
                ],
              ),
              )
              
              
            ),

            SizedBox(height: 20,),


            // -------------------------------------------------------------
            // SECCIÓN 2: DATOS DE ACCESO Y CONDICIONES
            // -------------------------------------------------------------
            Card(
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                  Text(
                    "Datos de Acceso",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 20,),

                  TextField(
                    controller: correoController,
                    keyboardType: TextInputType.emailAddress, //Muestra el teclado con @
                    decoration: InputDecoration(
                      labelText: "Correo electrónico *",
                      hintText: 'ejemplo@correo.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      errorText: errorCorreo,
                      prefixIcon: Icon(Icons.email_outlined)
                    ),
                  ),

                  SizedBox(height: 20,),

                  TextField(
                    controller: contrasenaController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      labelText: "Contraseña *",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              obscureText = !obscureText;
                            });
                          }, 
                          icon: Icon(
                            obscureText ? Icons.visibility_off : Icons.visibility,
                          )
                        ),
                      errorText: errorContra,
                      prefixIcon: Icon(Icons.password_outlined)
                    ),
                  ),

                  SizedBox(height: 20,),

                  TextField(
                    controller: confirmaContrasenaController,
                    obscureText: obscureText2,
                    decoration: InputDecoration(
                      labelText: "Confirmar la contraseña *",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              obscureText2 = !obscureText2;
                            });
                          }, 
                          icon: Icon(
                            obscureText2 ? Icons.visibility_off : Icons.visibility,
                          )
                        ),
                      errorText: errorConfContra,
                      prefixIcon: Icon(Icons.password_outlined)
                    ),
                  ),

                  SizedBox(height: 20,),


                  Row(
                    children: [
                      Checkbox(
                        value: seleccionado, 
                        onChanged: (bool? value){
                          setState(() {
                            seleccionado = value ?? false;
                          });
                        }
                      ),
                      Expanded(
                        child: Text("Acepta los términos y condiciones *"))
                    ],
                  ),

                  //Aqui mostramos en error de la casilla
                  if (errorTerminos != null)
                    Text(errorTerminos!,
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                        ),
                      ),
                  
                ],
                ),
                
              ),
            ),
                  
            SizedBox(height: 20,),


            // -------------------------------------------------------------
              // BOTONES DE ACCIÓN (LIMPIAR Y REGISTRAR)
              // -------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: (){
                    validarFormulario();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IniciarSesion(
                          contrasena: contrasenaController.text,
                          correo: correoController.text,
                          nombre: nombreController.text,
                          apellidos: apellidosController.text,
                          telefono: telefonoController.text,
                          fecha: fechaNacimientoController.text,
                          pais: opcionSeleccionada ?? '',
                        ),
                      ),
                    );
                  }, 
                  child: Text("Enviar")
                ),

                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      limpiarCampos();
                    });
                  },
                  child: Text("Limpiar")
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}



// -------------------------------------------------------------
// 2ª PANTALLA
// -------------------------------------------------------------

class IniciarSesion extends StatefulWidget {
  final String contrasena;
  final String correo;
  final String nombre;
  final String apellidos;
  final String telefono;
  final String fecha;
  final String pais;


  IniciarSesion({
    super.key,
    required this.contrasena,
    required this.correo,
    required this.nombre,
    required this.apellidos,
    required this.telefono,
    required this.fecha,
    required this.pais,
  });

  @override
  State<IniciarSesion> createState() => IniciarSesionState();
}


class IniciarSesionState extends State<IniciarSesion> {
  final correoInicioController = TextEditingController();
  final contraInicioController = TextEditingController();

  String? errorCorreoIncio;
  String? errorContraInicio;
  String? errorLogin;

  bool obscureText = true;

  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
  );

  void validarFormulario (){
    setState(() {
      //1. Validar el correo
      if ( contraInicioController.text.isEmpty) {
        errorCorreoIncio = "El correo es obligatorio";
      } else if (!emailRegex.hasMatch(correoInicioController.text)){
        errorCorreoIncio = "Formato de correo invalido";
      } else {
        errorCorreoIncio = null;
      }

      //2. Contraseña
      if ( contraInicioController.text.isEmpty){
        errorContraInicio = "La contraseña es obligatoria";
      } else{
        errorContraInicio = null;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sesion")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            //CIRCULITO DE AVATAR
           Container(
                padding: EdgeInsets.all(
                  4,
                ), // Este padding actúa como el grosor del borde blanco
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 35, // Tamaño de la foto
                  backgroundColor: Colors.deepPurpleAccent,
                  child: Icon(Icons.person_2_outlined)
                ),
            ),
            
            
            SizedBox(height: 20,),

            Text("Bienvenido"),

            SizedBox(height: 20,),

            //CARD Y CONTAINER PARA PONER LOS DOS TEXTFIELDS
            Card(
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    //CAMPO DE CORREO
                    TextField(
                      controller: correoInicioController,
                      keyboardType: TextInputType.emailAddress, //Muestra el teclado con @
                      decoration: InputDecoration(
                        labelText: "Correo electrónico *",
                        hintText: 'ejemplo@correo.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)
                        ),
                        errorText: errorCorreoIncio,
                        prefixIcon: Icon(Icons.email_outlined)
                      ),
                    ),

                    SizedBox(height: 20,),

                    //CAMPO DE CONTRASEÑA
                    TextField(
                      controller: contraInicioController,
                      obscureText: obscureText,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: "Contraseña *",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)
                        ),
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              obscureText = !obscureText;
                            });
                          }, 
                          icon: Icon(
                            obscureText ? Icons.visibility_off : Icons.visibility,
                          )
                        ),
                        errorText: errorContraInicio,
                        prefixIcon: Icon(Icons.password_outlined)
                      ),
                    ),

                    SizedBox(height: 20,),

                    //BOTON PARA VALIDAR LOS CAMPOS Y PASAR A LA SIGUIENTE PANTALLA
                    ElevatedButton(
                      onPressed: (){
                        setState(() {
                          validarFormulario();
                          if(correoInicioController.text == widget.correo && contraInicioController.text == widget.contrasena){
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => App(
                                  nombre: widget.nombre,
                                  apellidos: widget.apellidos,
                                  correo: widget.correo,
                                  telefono: widget.telefono,
                                  fecha: widget.fecha,
                                  pais: widget.pais,
                                ),
                              ),
                            );
                          } else {
                            setState(() {
                              errorLogin = "Correo o contraseña incorrectos";
                            });
                          }
                        });
                        
                      }, 
                      child: Text("Entrar")
                    )
                  ],
                ),
              ),
            ),

            SizedBox(height: 20,),

            //WIDGET QUE ENVUELVE UN TEXTO PARA PONERLE UN ONTAP
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Text(
                "¿No tienes cuenta? Registrate",
                style: TextStyle(color: Colors.blue)),)
          ],
        )
      )
    );
  }
}




// -------------------------------------------------------------
// 3ª PANTALLA
// -------------------------------------------------------------

//LLAMADA A LA API
class Foto{
  final String id;
  final String autor;

  Foto({required this.id, required this.autor});

  // Imagen con tamaño fijo para que cargue rápido
  String get url => 'https://picsum.photos/id/$id/600/750';

  factory Foto.fromJson(Map<String, dynamic> json) {
    return Foto(id: json['id'], autor: json['author']);
  }
}

Future<List<Foto>> obtenerFotos() async {
  final respuesta = await http.get(
    Uri.parse('https://picsum.photos/v2/list?limit=50'),
  );

  if (respuesta.statusCode != 200) {
    throw Exception('Error al cargar las fotos');
  }

  final List datos = jsonDecode(respuesta.body);
  return datos.map((f) => Foto.fromJson(f)).toList();
}


Widget mensajeCentral(IconData icono, String texto) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 48, color: Colors.grey),
        SizedBox(height: 12),
        Text(texto),
      ],
    ),
  );
}



class App extends StatefulWidget {
  final String nombre;
  final String apellidos;
  final String correo;
  final String telefono;
  final String fecha;
  final String pais;

  App({
    super.key,
    required this.nombre,
    required this.apellidos,
    required this.correo,
    required this.telefono,
    required this.fecha,
    required this.pais,
  });
  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  int indiceSeleccionado = 0;
  late Future<List<Foto>> futuroFotos;
  final Set<String> favoritos = {}; // ids de las fotos marcadas
  String colorSeleccionado = 'Por defecto';


  final List<IconData> iconos = [
    Icons.feed,
    Icons.search,
    Icons.favorite_border,
    Icons.post_add,
    Icons.picture_as_pdf,
    Icons.settings,
  ];

  String get iniciales {
    final n = widget.nombre.isNotEmpty ? widget.nombre[0] : '';
    final a = widget.apellidos.isNotEmpty ? widget.apellidos[0] : '';
    return (n + a).toUpperCase();
  }

  Widget construirDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Cabecera con avatar, nombre completo y correo
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.grey.shade800),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                iniciales,
                style: TextStyle(fontSize: 24, color: Colors.black87),
              ),
            ),
            accountName: Text("${widget.nombre} ${widget.apellidos}"),
            accountEmail: Text(widget.correo),
          ),

          // Datos personales
          ListTile(
            leading: Icon(Icons.phone_outlined),
            title: Text("Teléfono"),
            subtitle: Text(widget.telefono),
          ),
          ListTile(
            leading: Icon(Icons.cake_outlined),
            title: Text("Fecha de nacimiento"),
            subtitle: Text(widget.fecha),
          ),
          ListTile(
            leading: Icon(Icons.public),
            title: Text("País"),
            subtitle: Text(widget.pais),
          ),

          Divider(),

          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              "Secciones",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // Las seis pestañas: al pulsar, cambia la pestaña y cierra el menú
          for (int i = 0; i < titulos.length; i++)
            ListTile(
              leading: Icon(iconos[i]),
              title: Text(titulos[i]),
              selected: indiceSeleccionado == i,
              onTap: () {
                setState(() => indiceSeleccionado = i);
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }

  final List<String> titulos = ['Feeds', 'Buscar', 'Favoritos', 'Post', 'Exportar', 'Configuracion'];

  @override
  void initState() {
    super.initState();
    futuroFotos = obtenerFotos(); // una sola vez
  }

  void alternarFavorito(String id) {
    setState(() {
      if (favoritos.contains(id)) {
        favoritos.remove(id);
      } else {
        favoritos.add(id);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: obtenerColor(colorSeleccionado),
      appBar: AppBar(title: Text(titulos[indiceSeleccionado])),
      drawer: construirDrawer(),
      
      body: FutureBuilder<List<Foto>>(
        future: futuroFotos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final fotos = snapshot.data!;

          // IndexedStack mantiene el estado de cada pestaña (scroll, búsqueda...)
          return IndexedStack(
            index: indiceSeleccionado,
            children: [
              Feeds(fotos: fotos, favoritos: favoritos, onFavorito: alternarFavorito),
              Buscar(),
              Favoritos(fotos: fotos, favoritos: favoritos, onFavorito: alternarFavorito),
              Post(fotos: fotos, favoritos: favoritos, onFavorito: alternarFavorito),
              Exportar(fotos: fotos),
              Configuracion(
                colorSeleccionado: colorSeleccionado,
                onColorCambiado: (nuevo) => setState(() => colorSeleccionado = nuevo),
              ),
            ],
          );
        },
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: indiceSeleccionado,
        onDestinationSelected: (index) {
          setState(() => indiceSeleccionado = index);
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.feed), label: 'Feeds'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Favoritos'),
          NavigationDestination(icon: Icon(Icons.post_add), label: 'Post'),
          NavigationDestination(icon: Icon(Icons.picture_as_pdf), label: 'Exportar'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Configuracion'),
        ],
      ),
    );
  }
}


//La misma tarjeta se usa en las tres pantallas
class FotoCard extends StatelessWidget {
  final Foto foto;
  final bool esFavorito;
  final VoidCallback onFavorito;

  FotoCard({
    super.key,
    required this.foto,
    required this.esFavorito,
    required this.onFavorito,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500), // como en tu captura en pantallas anchas
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(child: Text(foto.autor[0])),
                title: Text(foto.autor, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Foto #${foto.id}"),
              ),
              AspectRatio(
                aspectRatio: 4 / 5,
                child: Image.network(
                  foto.url,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progreso) {
                    if (progreso == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onFavorito,
                    icon: Icon(
                      esFavorito ? Icons.favorite : Icons.favorite_border,
                      color: esFavorito ? Colors.red : null,
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.chat_bubble_outline)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.share)),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: foto.autor,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: " Disfrutando de un gran día."),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



//CLASE FEEDS
class Feeds extends StatelessWidget {
  final List<Foto> fotos;
  final Set<String> favoritos;
  final void Function(String) onFavorito;

  Feeds({
    super.key,
    required this.fotos,
    required this.favoritos,
    required this.onFavorito,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: fotos.length,
      itemBuilder: (context, index) {
        final foto = fotos[index];
        return FotoCard(
          foto: foto,
          esFavorito: favoritos.contains(foto.id),
          onFavorito: () => onFavorito(foto.id),
        );
      },
    );
  }
}


class Buscar extends StatelessWidget {
  Buscar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar por autor...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 12),
              FilledButton(
                onPressed: () {}, // sin función por ahora
                child: Text("Buscar"),
              ),
            ],
          ),
        ),
        Expanded(
          child: mensajeCentral(
            Icons.image_search,
            "Escribe el nombre de un autor y pulsa Buscar.",
          ),
        ),
      ],
    );
  }
}


class Favoritos extends StatelessWidget {
  final List<Foto> fotos;
  final Set<String> favoritos;
  final void Function(String) onFavorito;

  Favoritos({
    super.key,
    required this.fotos,
    required this.favoritos,
    required this.onFavorito,
  });

  @override
  Widget build(BuildContext context) {
    final lista = fotos.where((f) => favoritos.contains(f.id)).toList();

    if (lista.isEmpty) {
      return mensajeCentral(Icons.favorite_border, "Aún no tienes fotos favoritas.");
    }

    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final foto = lista[index];
        return FotoCard(
          foto: foto,
          esFavorito: true,
          onFavorito: () => onFavorito(foto.id),
        );
      },
    );
  }
}


  //Esta parte no funciona, deberia hacerla que al pulsar el boton añada una publicación

class Post extends StatefulWidget{
  final List<Foto> fotos;
  final Set<String> favoritos;
  final void Function(String) onFavorito;

  Post({
    super.key,
    required this.fotos,
    required this.favoritos,
    required this.onFavorito,
  });

  @override
  State<Post> createState() => PostState();
}


class PostState extends State<Post> {
  final List<String> posts = [];
  final textoController = TextEditingController();

  //Funcion que libera memoria cuando el widget deja de existir
  @override 
  void dispose(){
    textoController.dispose();
    super.dispose();
  }

  Future<void> nuevoPost() async {
    textoController.clear();

    final texto = await showDialog <String>(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Nuevo Post"),
        content: TextField(
          controller: textoController,
          autofocus: true,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "¿Que quieres contar?",
            border: OutlineInputBorder()
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text("Cancelar")
          ),
          FilledButton(
            onPressed: (){
              Navigator.pop(context, textoController.text.trim());
            }, 
            child: Text("Publicar"))
        ],
      )
    );

    if (texto != null && texto.isNotEmpty) {
      setState(() {
        posts.insert(0, texto);
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: posts.isEmpty
      ? mensajeCentral(
        Icons.post_add, 
        "Todavia no has escrito ningún post.\nPulsa + para crear el primero"
        )
      : ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.person),),
                title: Text(posts[index]),
                trailing: IconButton(
                  onPressed: (){
                    setState(() {
                      posts.removeAt(index);
                    });
                  }, 
                  icon: Icon(Icons.delete_outlined)
                ),
              ),
            );
          }
        ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          nuevoPost();
        },
        child: Icon(Icons.add),
      ),   
    );
  }
}



class Exportar extends StatelessWidget {
  final List<Foto> fotos;

  Exportar({super.key, required this.fotos});

  Future<void> exportarPdf(BuildContext context, List<Foto> listaFotos) async {
    // Diálogo de carga mientras se descargan las imágenes
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Expanded(child: Text("Descargando fotos y creando PDF...")),
          ],
        ),
      ),
    );

    try {
      final pdf = pw.Document();

      // Una página por foto, con el autor y la imagen completa
      for (final foto in listaFotos) {
        final respuesta = await http.get(Uri.parse(foto.url));

        if (respuesta.statusCode == 200) {
          final imagenPdf = pw.MemoryImage(respuesta.bodyBytes);

          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context ctx) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      "Autor: ${foto.autor}",
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      "Foto #${foto.id}",
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.SizedBox(height: 24),
                    // BoxFit.contain: la imagen sale completa y sin deformarse
                    pw.Expanded(
                      child: pw.Image(imagenPdf, fit: pw.BoxFit.contain),
                    ),
                  ],
                );
              },
            ),
          );
        }
      }

      // Cerramos el diálogo de carga
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // Vista previa nativa para guardar o imprimir
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'fotos_exportadas.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al exportar PDF: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Las 10 primeras fotos de la app (no solo favoritas)
    final lista = fotos.take(10).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.picture_as_pdf, size: 56),
                SizedBox(height: 12),
                Text(
                  "Exportar fotos a PDF",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Se exportarán estas ${lista.length} fotos descargadas de la API, una por página y con el nombre de su autor.",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),

                // Vista previa en miniatura de las 10 imágenes
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: lista.map((foto) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        foto.url,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => exportarPdf(context, lista),
                    icon: Icon(Icons.download),
                    label: Text("Exportar PDF"),
                  ),
                ),

                SizedBox(height: 12),

                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Exportación cancelada")),
                    );
                  },
                  child: Text(
                    "Cancelar exportación",
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// Convierte el nombre del color en un Color real (función global para usarla desde AppState)
Color obtenerColor(String nombreColor) {
  switch (nombreColor) {
    case 'Verde':
      return Colors.green.shade100;
    case 'Rojo':
      return Colors.red.shade100;
    case 'Amarillo':
      return Colors.amber.shade100;
    case 'Azul':
      return Colors.blue.shade100;
    case 'Morado':
      return Colors.purple.shade100;
    case 'Rosa':
      return Colors.pink.shade100;
    default:
      return Colors.white; // 'Por defecto'
  }
}


class Configuracion extends StatelessWidget {

  final String colorSeleccionado;
  final void Function(String) onColorCambiado;

  Configuracion({
    super.key,
    required this.colorSeleccionado,
    required this.onColorCambiado,
    });

  final List<String> colores = [
    'Por defecto',
    'Verde',
    'Rojo',
    'Amarillo',
    'Azul',
    'Morado',
    'Rosa',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Color de Fondo",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Elige el color de fondo"),
            SizedBox(height: 8),
            Text("Seleccionado: $colorSeleccionado"),
            SizedBox(height: 20),

            // Círculos de colores
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: colores.map((nombre) {
                final bool esElegido = nombre == colorSeleccionado;
                return GestureDetector(
                  onTap: () => onColorCambiado(nombre),
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: esElegido ? Colors.black : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: obtenerColor(nombre),
                      child: nombre == 'Por defecto'
                          ? Icon(Icons.format_color_reset, color: Colors.grey)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: () => onColorCambiado('Por defecto'),
              child: Text("Restablecer"),
            ),
          ],
        ),
      ),
    );
  }
}