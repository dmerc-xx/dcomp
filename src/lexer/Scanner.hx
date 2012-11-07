package lexer;
import tree.AST;

/**
 * scans a source file and
 * creates a list of tokens from the source
 * @author skeq
 */

class Scanner 
{
	var out:Array<Token>;
	var src:String;
	public function new(src:String) 
	{
		if (src.length == 0)
			throw 'empty file';
		this.src = src;
	}
	public function analyze() {
		var lines = BroadPhase.parse(src);
		lines = CommandScanner.parse(lines);
		var t = new Lexer();
		out = t.parse(lines);
	}
	public function output():Array<Token> {
		return out;
	}
}