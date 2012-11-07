package tree;

/**
 * ...
 * @author skeq
 */

class AST extends ASTNode
{
	
}
class ASTNode {
	public var parent:ASTNode;
	public var children:Array<ASTNode>;
	public var data:Token;
	public function new(){
		children = new Array<ASTNode>();
	}
	public function addChild(token:Token):ASTNode {
		var n = new ASTNode();
		n.parent = this;
		n.data = token;
		children.push(n);
		return n;
	}
	public function length():Int {
		return children.length;
	}
	public function treedump(ind:String = ''):String{
		var o:String = (data == null)?ind + 'ROOT\n':ind + Std.string(data) + '\n';
		for (c in children){
			o += c.treedump(ind + '    ');
		}
		return o;
	}
	public function toString():String {
		return 'ast'+Std.string(this.data);
	}
}