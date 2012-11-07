package lexer;

/**
 * broad phase of lexing.
 * 1. splits lines
 * 2. ignores whitespace lines
 * 3. figures out indentation
 * @author skeq
 */

class BroadPhase 
{
	public function new() 
	{
		
	}
	public static function parse(input:String):Array<Line> {
		var lines:Array<String> = input.split('\n');
		var out:Array<Line> = new Array<Line>();
		
		var RisWhiteSpace:EReg = ~/^[\r\n\t\s]*$/;
		var Rindent:EReg = ~/^[\r\n\t\s]*[^\r\n\t\s]/;
		
		var indent:Int = 1;
		for (i in 0...lines.length) {
			var line:String = lines[i];
			if (!RisWhiteSpace.match(line)) {
				//figure out the indent
				var lineIndent:Int = 0;
				if (Rindent.match(line)) {
					var current_indent:Int = Rindent.matched(0).length;
					if ( indent != current_indent) {
						lineIndent = current_indent - indent;
					}
					indent = current_indent;
				}
				var tline:String = StringTools.rtrim(StringTools.ltrim(lines[i]));
				out.push( { i:i, indent:lineIndent, data:tline } );
			}
		}
		return out;
	}
}
typedef Line = {
	var i:Int;
	var indent:Int;
	var data:String;
}