
import 'package:image_picker/image_picker.dart';

class FilePicker {
  Future<XFile?> pickFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print('file name is ${image.path}');
      return image;
    }
    return null;
  }
}
