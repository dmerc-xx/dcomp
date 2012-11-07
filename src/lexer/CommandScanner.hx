package lexer;
import lexer.BroadPhase;
/**
 * parses @ compiler commands
 * @author skeq
 */

class CommandScanner 
{

	public function new() 
	{
		
	}
	public static function parse(input:Array<Line>):Array<Line> {
		var Rinclude : EReg = ~/^@/;
		
		for ( i in 0...input.length ) {
			var line:Line = input[i];
			if (Rinclude.match(line.data)) {
				input.slice(i, 1);
			}
		}
		return input;
	}
}