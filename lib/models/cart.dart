import	'../models/products.dart';
class	Cart	{
		static	final	List<Product>	_items	=	[];
		static	void	add(Product	product)	=>	_items.add(product);
		static	void	remove(Product	product)	=>	_items.remove(product);
		static	List<Product>	get	items	=>	_items;
		static	double	get	total	=>	_items.fold(0,	(sum,	item)	=>	sum	+	
item.price);
}