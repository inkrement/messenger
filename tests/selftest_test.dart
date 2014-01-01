import 'package:unittest/unittest.dart';
import 'package:unittest/compact_vm_config.dart';
import 'dart:io';

main(){
  
  useCompactVMConfiguration();
  
  test('max 80 chars per line',(){
    
    Directory libs = new Directory("../lib");
    
    List<FileSystemEntity> l = libs.listSync(recursive: true);
    
    l.forEach((FileSystemEntity i){
      if (i is File){
        List<String> lines = i.readAsLinesSync();
        
        int ln = 0;
        
        lines.forEach((String l){
          ln++;
          expect(l.length, lessThan(80), reason:"To long line in file ${i.path} line ${ln}");
        });
      }
    });
  });
  
}
    