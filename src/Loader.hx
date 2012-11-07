package ;
#if neko
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;
#elseif flash

#end

class Loader 
{

	public static function getFile(fname:String):String {
		#if neko
		if (FileSystem.exists(fname)) {
			return File.getContent(fname);
		}else {
			throw "file '" + fname + "' does not exist";
			return null;
		}
		#elseif flash
			return '';
		#end
	}
	public static function write(fname:String, content:String) {
		#if neko
		var fh:FileOutput = File.write(fname);
		fh.writeString(content);
		fh.close();
		#elseif flash
			//
		#end
	}
}