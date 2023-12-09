import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_pmsn2023/widgets/qr_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:final_project_pmsn2023/pages/address_search.dart';
import 'package:final_project_pmsn2023/pages/place_services.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class InvitationScreen extends StatefulWidget {
  const InvitationScreen({super.key});

  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

///DROPDOWN
class DropdownMenuEvento extends StatefulWidget {
  const DropdownMenuEvento({super.key});

  @override
  State<DropdownMenuEvento> createState() => _DropdownMenuEventoState();
}

const List<String> list = <String>[
  'Fiesta',
  'Convivio',
  'Peda',
  'Posada',
  'Otro'
];

String _type = "Fiesta";

class _DropdownMenuEventoState extends State<DropdownMenuEvento> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: list.first,
      //expandedInsets: const EdgeInsets.all(0),
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          _type = value!;
        });
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}

class _InvitationScreenState extends State<InvitationScreen> {
  late DateTime fecha;
  late TimeOfDay hora;

  String _name = '';
  String _description = '';
  String? _ubicationName = '';
  double? _lat = 0;
  double? _lot = 0;
  User? user = FirebaseAuth.instance.currentUser;

  final _controller = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final String title = "Map Sample";
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    fecha = DateTime.now();
    hora = TimeOfDay.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(750, 1334));
    String formattedDate = DateFormat('yyyy-MM-dd').format(fecha);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "assets/InvitApp.png",
              width: ScreenUtil().setWidth(110),
              height: ScreenUtil().setHeight(110),
            ),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: Text("InvitApp",
                    style: TextStyle(
                        fontFamily: "Poppins-Bold",
                        fontSize: ScreenUtil().setSp(46),
                        fontWeight: FontWeight.bold)))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          //width: double.infinity,
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),

          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Nuevo evento",
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(35),
                        fontFamily: "Poppins-Bold",
                        letterSpacing: .6)),
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
                Text("Nombre de el evento",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil().setSp(26))),
                TextField(
                  controller: _nameController,
                  onChanged: (value) {
                    _name = value;
                  },
                  decoration: const InputDecoration(
                      hintText: "Nombre de el evento",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15.0)),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
                Text("Descripción",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil().setSp(26))),
                TextField(
                  minLines: 1,
                  maxLines: 8,
                  controller: _descriptionController,
                  onChanged: (value) {
                    _description = value;
                  },
                  decoration: const InputDecoration(
                      hintText: "Descripción",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15.0)),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
                Text("Tipo de evento",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil().setSp(26))),
                const DropdownMenuEvento(),
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
                Text("Fecha",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil().setSp(26))),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          final result = await showDatePicker(
                              context: context,
                              initialDate: fecha,
                              firstDate: DateTime(2023),
                              helpText: "Seleccione la fecha del evento",
                              fieldLabelText: "Escribe la fecha de el evento",
                              fieldHintText: "Escribe la fecha de el evento",
                              errorFormatText: "Fecha no valida",
                              locale: const Locale('es', 'MX'),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365 * 2)));

                          if (result != null) {
                            setState(() {
                              fecha = result;
                            });
                          }
                        },
                        child: const Text("Seleccionar fecha")),
                    const SizedBox(
                      width: 40,
                    ),
                    Text(formattedDate,
                        style: TextStyle(
                            fontFamily: "Poppins-Medium",
                            fontSize: ScreenUtil().setSp(26))),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
                Text("Hora",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil().setSp(26))),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          final result = await showTimePicker(
                              context: context,
                              initialTime: hora,
                              helpText: "Seleccione la hora del evento",
                              initialEntryMode: TimePickerEntryMode.dial,
                              hourLabelText: "Horas",
                              minuteLabelText: "Minutos",
                              errorInvalidText: "Formato de hora no valida");

                          if (result != null) {
                            setState(() {
                              hora = result;
                            });
                          }
                        },
                        child: const Text("Seleccionar hora")),
                    const SizedBox(
                      width: 50,
                    ),
                    Text("${hora.format(context)} horas",
                        style: TextStyle(
                            fontFamily: "Poppins-Medium",
                            fontSize: ScreenUtil().setSp(26))),
                  ],
                ),
                const SizedBox(
                  width: 50,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
                Text("Ubicación",
                    style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil().setSp(26))),
                TextField(
                  controller: _controller,
                  readOnly: true,
                  onTap: () async {
                    // generate a new token here
                    final sessionToken = const Uuid().v4();
                    final Suggestion? result = await showSearch(
                      context: context,
                      delegate: AddressSearch(sessionToken),
                    );
                    // This will change the text displayed in the TextField
                    if (result != null) {
                      final placeDetails = await PlaceApiProvider(sessionToken)
                          .getPlaceDetailFromId(result.placeId);
                      setState(() {
                        _controller.text = result.description;
                        _ubicationName = placeDetails.ubicationName;
                        _lat = placeDetails.lat;
                        _lot = placeDetails.lot;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    icon: Container(
                      width: 10,
                      height: 10,
                      child: const Icon(
                        Icons.add_location_alt_outlined,
                        color: Colors.black,
                      ),
                    ),
                    hintText: "Selecciona la ubicacion",
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 15.0),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 8.0, top: 16.0),
                  ),
                ),
                const SizedBox(height: 20.0),
                /*  Text('Name: $_ubicationName'),
                Text('lat: $_lat'),
                Text('lot: $_lot'), */
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await db.collection('events').add({
                        'name': _name,
                        'description': _description,
                        'hour': hora.format(context),
                        'date': formattedDate,
                        'lat': _lat,
                        'lot': _lot,
                        'type': _type,
                        'ubication': _ubicationName,
                        'user': user?.uid,
                      }).then((value) => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GenerateQR(id: value.id),
                              ),
                            )
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromRGBO(0, 67, 186, 1), // Color de fondo
                      foregroundColor: Colors.white, // Color del texto
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins-Bold',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
