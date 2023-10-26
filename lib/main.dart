import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter UTS PAB(A)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController notaController = TextEditingController();
  TextEditingController namaPembeliController = TextEditingController();
  TextEditingController dateInputController = TextEditingController();
  TextEditingController jumlahBeliController = TextEditingController();
  TextEditingController diskonController = TextEditingController();
  TextEditingController ppnController = TextEditingController();
  TextEditingController grandTotalController = TextEditingController();
  TextEditingController uangDibayarController = TextEditingController();
  TextEditingController uangKembaliController = TextEditingController();

  String? jenisPelanggan;
  String hariLiburValue = 'Tidak';
  String saudaraValue = 'Tidak';
  bool abcValue = false;
  bool bbbValue = false;
  bool xyzValue = false;
  bool wwwValue = false;
  double diskon = 0;
  double hariLibur = 0;
  double saudara = 0;
  double abc = 0;
  double bbb = 0;
  double xyz = 0;
  double www = 0;
  double ppn = 0;
  double grandTotalNoPpn = 0;
  double grandTotalPpn = 0;
  double uangKembali = 0;

  void resetAllValue() {
    setState(() {
      jenisPelanggan = null;
      hariLiburValue = 'Tidak';
      saudaraValue = 'Tidak';
      abcValue = false;
      bbbValue = false;
      xyzValue = false;
      wwwValue = false;
      diskon = 0;
      hariLibur = 0;
      saudara = 0;
      abc = 0;
      bbb = 0;
      xyz = 0;
      www = 0;
      grandTotalNoPpn = 0;
      grandTotalPpn = 0;
      uangKembali = 0;
      notaController.text = '';
      namaPembeliController.text = '';
      dateInputController.text = '';
      jumlahBeliController.text = '';
      diskonController.text = '';
      ppnController.text = '';
      grandTotalController.text = '';
      uangDibayarController.text = '';
      uangKembaliController.text = '';
    });
  }

  void validateInput() {
    FormState? form = formKey.currentState;
    SnackBar message = const SnackBar(
      content: Text('Proses Selesai'),
    );

    if (form!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(message);
    }
  }

  void process() {
    setState(() {
      int? jumlahBeli;
      int? uangDibayar;
      if (jumlahBeliController.text != '' && uangDibayarController.text != '') {
        jumlahBeli = int.parse(jumlahBeliController.text);
        uangDibayar = int.parse(uangDibayarController.text);

        // diskon sesuai dengan jenis pelanggan
        if (jenisPelanggan != 'Biasa') {
          if (jenisPelanggan == 'Pelanggan') {
            diskon = jumlahBeli * 0.02;
          } else if (jenisPelanggan == 'Pelanggan Istimewa') {
            diskon = jumlahBeli * 0.04;
          }
        }
        diskonController.text = diskon.toString();

        // kondisi ketika hari libur
        if (hariLiburValue == 'Iya') {
          hariLibur = -2500;
        } else if (hariLiburValue == 'Tidak') {
          hariLibur = 0;
        }

        // saudara or not condition
        if (saudaraValue == 'Iya') {
          saudara = -5000;
        } else if (saudaraValue == 'Tidak') {
          saudara = 3000;
        }

        //jenis barang dibeli
        if (abcValue) {
          abc = 100;
        }
        if (bbbValue) {
          bbb = -500;
        }
        if (xyzValue) {
          xyz = 200;
        }
        if (wwwValue) {
          www = -100;
        }

        //ppn 10%
        grandTotalNoPpn =
            jumlahBeli - diskon + hariLibur + saudara + abc + bbb + xyz + www;
        ppn = grandTotalNoPpn * 0.1;
        ppnController.text = ppn.toString();

        //grand total with ppn
        grandTotalPpn = grandTotalNoPpn + ppn;
        grandTotalController.text = grandTotalPpn.toString();

        // uang kembali
        uangKembali = uangDibayar - grandTotalPpn;
        if (uangKembali < 0) {
          SnackBar message = const SnackBar(
            content: Text('Uang nya kurang :('),
          );
          ScaffoldMessenger.of(context).showSnackBar(message);
        }
        uangKembaliController.text = uangKembali.toString();

        if (uangKembali >= 0) {
          validateInput();
        }
      } else {
        SnackBar message = const SnackBar(
          content: Text(
              'Field "Jumlah pembelian" atau "Uang dibayar" masih belum terisi, sehingga Grand Total belum bisa diproses'),
        );
        ScaffoldMessenger.of(context).showSnackBar(message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'foto.png',
                    width: 200,
                  ),
                ],
              ),
              Container(
                height: 25,
              ),
              Form(
                key: formKey,
                child: SizedBox(
                  width: 500,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'No Nota',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              controller: notaController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Nomor nota tidak boleh kosong';
                                }
                              },
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nama Pembeli',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              controller: namaPembeliController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Nama pembeli tidak boleh kosong';
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Jenis',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              value: jenisPelanggan,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: [
                                'Biasa',
                                'Pelanggan',
                                'Pelanggan Istimewa',
                              ].map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              validator: (String? value) {
                                if (value == null) {
                                  return 'Jenis pembeli tidak boleh kosong';
                                }
                              },
                              onChanged: (String? newValue) {
                                setState(() {
                                  jenisPelanggan = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tanggal Beli',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              readOnly: true,
                              controller: dateInputController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(
                                  Icons.calendar_month_rounded,
                                ),
                              ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2050),
                                );
                                if (pickedDate != null) {
                                  var formatDate = DateFormat('d-MM-yyyy');
                                  dateInputController.text =
                                      formatDate.format(pickedDate);
                                }
                              },
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Tanggal beli tidak boleh kosong';
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Jumlah Pembelian',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              controller: jumlahBeliController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Diskon',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              controller: diskonController,
                              enabled: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Hari Libur',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 125,
                                  child: RadioListTile(
                                    title: const Text('Tidak'),
                                    value: "Tidak",
                                    groupValue: hariLiburValue,
                                    onChanged: (value) {
                                      setState(() {
                                        hariLiburValue = value.toString();
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 125,
                                  child: RadioListTile(
                                    title: const Text('Iya'),
                                    value: "Iya",
                                    groupValue: hariLiburValue,
                                    onChanged: (value) {
                                      setState(() {
                                        hariLiburValue = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Saudara',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 125,
                                  child: RadioListTile(
                                    title: const Text('Tidak'),
                                    value: "Tidak",
                                    groupValue: saudaraValue,
                                    onChanged: (value) {
                                      setState(() {
                                        saudaraValue = value.toString();
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 125,
                                  child: RadioListTile(
                                    title: const Text('Iya'),
                                    value: "Iya",
                                    groupValue: saudaraValue,
                                    onChanged: (value) {
                                      setState(() {
                                        saudaraValue = value.toString();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Jenis barang dibeli',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 75,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            checkColor: Colors.white,
                                            activeColor: Colors.blue,
                                            value: abcValue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                abcValue = value!;
                                              });
                                            },
                                          ),
                                          const Text('ABC'),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 75,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            checkColor: Colors.white,
                                            activeColor: Colors.blue,
                                            value: bbbValue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                bbbValue = value!;
                                              });
                                            },
                                          ),
                                          const Text('BBB'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 75,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            checkColor: Colors.white,
                                            activeColor: Colors.blue,
                                            value: xyzValue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                xyzValue = value!;
                                              });
                                            },
                                          ),
                                          const Text('XYZ'),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 75,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            checkColor: Colors.white,
                                            activeColor: Colors.blue,
                                            value: wwwValue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                wwwValue = value!;
                                              });
                                            },
                                          ),
                                          const Text('WWW'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'PPN',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              controller: ppnController,
                              enabled: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'GRAND TOTAL',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              controller: grandTotalController,
                              enabled: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'UANG DIBAYAR',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              controller: uangDibayarController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'UANG KEMBALI',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              controller: uangKembaliController,
                              enabled: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 175,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                FormState? form = formKey.currentState;
                                form!.validate();
                                if (form.validate()) {
                                  process();
                                }
                              },
                              child: const Text('PROSES'),
                            ),
                          ),
                          SizedBox(
                            width: 175,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                resetAllValue();
                              },
                              child: const Text('RESET'),
                            ),
                          ),
                        ],
                      ),
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
