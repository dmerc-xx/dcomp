package lexer;

typedef TokenIterator<T> = 
{> Iterator<T>, 
     public function reset():Void; 
}

class TokenList<T>
{
	var head:TLN<T>;
	var tail:TLN<T>;
	var curr:TLN<T>;
	public function new() 
	{
		head = new TLN(null);
		tail = new TLN(null);
		curr = head;
		head.next = tail;
		tail.prev = head;
	}
	public function next():T {
		if(curr.next != null){
			curr = curr.next;
			return curr.data;
		}else {
			throw 'last element in list';
			return null;
		}
	}
	public function hasNext():Bool {
		return (curr.next != null && curr.next.next != null);
	}
	public function peekNext():T {
		if (curr == tail || curr.next == tail)
			return null;
		else
			return curr.next.data;
	}
	public function peekPrev():T {
		if (curr == head || curr.prev == head)
			return null;
		else
			return curr.prev.data;
	}
	public function push(v:T) {
		var n:TLN<T> = new TLN<T>(v);
		n.prev = tail.prev;
		tail.prev.next = n;
		
		n.next = tail;
		tail.prev = n;
	}
	public static function fromTokenArray(a:Array<Token>):TokenList<Token> {
		var r:TokenList<Token> = new TokenList<Token>();
		for (i in 0...a.length) {
			r.push(a[i]);
		}
		return r;
	}
}
private class TLN<T> {
	public var data:T;
	public var next:TLN<T>;
	public var prev:TLN<T>;
	public function new(d:T) {
		data = d;
	}
}