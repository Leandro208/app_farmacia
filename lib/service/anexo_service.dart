import 'dart:convert';
import 'dart:io';

import 'package:app_farmacia/service/notification_service.dart';
import 'package:app_farmacia/utils/path_provider.dart';
import 'package:app_farmacia/utils/tipo_arquivo_enum.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AnexoService {
  Future<String?> anexarImagem(TipoArquivo tipoArquivo) async {
    PermissionStatus status = await checagemPermissaoAndroid();
    if (status.isDenied || status.isPermanentlyDenied) {
      abrirConfig();
      return null;
    }
    FilePickerResult? result;
    switch (tipoArquivo) {
      case TipoArquivo.galeria:
        result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );
        break;
      case TipoArquivo.storage:
        result = await FilePicker.platform.pickFiles();
        break;
      case TipoArquivo.camera:
        XFile? imagemTemporaria = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          preferredCameraDevice: CameraDevice.front,
        );
        if (imagemTemporaria != null) {
          return converteParaBase64(imagemTemporaria.path);
        }
        break;
      default:
    }
    if (result != null) {
      return converteParaBase64(result.files.single.path ?? '');
    }
    return null;
  }

  Future<String> converteParaBase64(String? imagePath) async {
    File imagefile = File(imagePath!);
    Uint8List imagebytes = await imagefile.readAsBytes();
    return base64.encode(imagebytes);
  }

  static Uint8List base64Decode(String source) => base64.decode(source);

  Future<File?> converteBase64ParaFile(
    String? base64,
    String? nome,
    String? type,
  ) async {
    File? file;
    Directory fileDir = await getTemporaryDirectory();
    final decodedBytes = base64Decode(base64!.trim());
    nome = nome?.substring(0, nome.indexOf('.'));
    type = type?.substring(type.indexOf('/') + 1, type.length);

    file = File('${fileDir.path}/$nome.$type');
    file.writeAsBytesSync(decodedBytes);

    return file;
  }

  Future salvarArquivoEmDocumentos(
    String? base64,
    String? nome,
    String? type,
    String? path,
  ) async {
    NotificationService().initializeNotifications(path);
    final PermissionStatus status = await checagemPermissaoAndroid();
    if (status.isGranted) {
      try {
        final PathProvider localPath = PathProvider();
        final fileDir = await localPath.downloadPath();
        final Uint8List decodedBytes = base64Decode(base64!.trim());

        type = type?.substring(type.indexOf('/') + 1, type.length);
        nome = nome?.substring(0, nome.indexOf('.'));

        RandomAccessFile file =
            File('$fileDir/$nome.$type').openSync(mode: FileMode.write);
        file.writeFromSync(decodedBytes);
        await file.close();
        NotificationService().showNotification(
          'Arquivo baixado',
          'Seu arquivo foi baixado com sucesso!',
        );

        await OpenFilex.open(file.path);
      } catch (e) {
        //TODO: Adicionar erro para quando não for possivel salvar
      }
    } else {}
  }

  void openFile(File imagemselecionada) async {
    OpenFilex.open(imagemselecionada.path);
  }

  Future<PermissionStatus> checagemPermissaoAndroid() async {
    final PermissionStatus status = await Permission.storage.request();

    if (!Platform.isAndroid) return status;

    final int versaoSDK = (await DeviceInfoPlugin().androidInfo).version.sdkInt;

    //android 13 pra frente
    if (versaoSDK >= 33) return PermissionStatus.granted;

    return status;
  }

  abrirConfig() {
    // return showDialog(builder: (BuildContext context) {
    //   return Padding(
    //     padding: const EdgeInsets.only(left: 20),
    //     child: AlertDialog(
    //       shape: const RoundedRectangleBorder(
    //         borderRadius: BorderRadius.all(Radius.circular(8)),
    //       ),
    //       title: const Text(
    //         'Permissão Negada',
    //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //       ),
    //       content: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         mainAxisSize: MainAxisSize.min,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           const Text(
    //             'Para usar este recurso, você precisa aceitar as permitições.',
    //             style: TextStyle(
    //               fontSize: 15,
    //               height: 1.3,
    //             ),
    //           ),
    //           const SizedBox(height: 30),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: [
    //               GestureDetector(
    //                 onTap: () {
    //                   Navigator.of(context).pop();
    //                   openAppSettings();
    //                 },
    //                 child: Container(
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(6),
    //                     color: Colors.orange,
    //                   ),
    //                   child: const Padding(
    //                     padding: EdgeInsets.all(10),
    //                     child: Text(
    //                       'Configurações',
    //                       style: TextStyle(
    //                         fontSize: 14,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(
    //                 width: 20,
    //               ),
    //               GestureDetector(
    //                 onTap: () => Navigator.of(context).pop(),
    //                 child: const Text(
    //                   'Cancelar',
    //                   style: TextStyle(
    //                     fontSize: 14,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //               )
    //             ],
    //           )
    //         ],
    //       ),
    //     ),
    //   );
    // });
  }
}
