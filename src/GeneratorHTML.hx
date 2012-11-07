package ;
import tree.AST;

/**
 * ...
 * @author skeq
 */

class GeneratorHTML 
{
	var out:String;
	var ast:AST;
	var indent:String;
	var table:Table;
	public function new(ast:AST) 
	{
		out = '';
		this.ast = ast;
		table = Table.instance();
	}
	public function generate() {
		indent = '';
		for (c in ast.children) {
			parse(c);
		}
	}
	function parse(node:ASTNode) {
		var token:Token = node.data;

		if (node.data != null) {
			switch (token.type) {
				case TokenType.COMMENT:
					wcom(token.cargo);
				case TokenType.SOURCE:
					w(token.cargo);
				case TokenType.ELEMENT:
					//w('<' + name + '>' + d + '</' + name + '>');
					w('<' + token.cargo + ' />');
				case TokenType.ATTRIBUTEID:
					w(Std.format(" id='${token.cargo}' "),false);
				case TokenType.ATTRIBUTECLASS:
					w(Std.format(" class='${token.cargo}' "),false);
				case TokenType.VAR:
					if ( table.exists( token.cargo ) ){
						w('|var|'+table.get(token.cargo));
					}else {
						wcom(Std.format("var ${token.cargo} not found"));
					}
					//out += Table.instance().get(n);
				default:
					wcom('unspecified rule: '+Std.string(token));
			}
		}
		for (c in node.children) {
			indent += '  ';
			parse(c);
			indent = indent.substr(2);
		}
	}
	inline function w(k:Dynamic,?endline:Bool = true) {
		out += indent + Std.string(k);
		if (endline) out += '\n';
	}
	inline function wcom(k:Dynamic, ?endline:Bool = true) {
		w('<!--' + Std.string(k) + '-->',endline);
	}
	public function output():String {
		return out;
	}
}