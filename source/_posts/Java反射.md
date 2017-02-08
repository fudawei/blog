title: Java反射
date: 2014-05-04 18:25:02
categories: [Java,Java基础]
tags: [Java,Java基础,反射]
---
1、Java反射的概念
	反射含义：可以获取正在运行的Java对象。
2、Java反射的功能
	1)可以判断运行时对象所属的类
	2)可以判断运行时对象所具有的成员变量和方法
	3)通过反射甚至可以调用到private的方法
	4)生成动态代理
3、实现Java反射的类
	1)Class：它表示正在运行的Java应用程序中的类和接口
	2)Field：提供有关类或接口的属性信息，以及对它的动态访问权限
	3)Constructor：提供关于类的单个构造方法的信息以及对它的访问权限
	4)Method：提供关于类或接口中某个方法信息

```
POJO
public class Employee implements Cloneable{
	private String name;
	private int age;
	private int[] arr;
	public Employee(){

	}
	public Employee(String name, int age, int[] arr) {
		this.name = name;
		this.age = age;
		this.arr = arr;
	}
	public int[] getArr() {
		return arr;
	}
	public void setArr(int[] arr) {
		this.arr = arr;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}

	public void display(){
		System.out.println("name="+name+" ;age="+age);
	}

	public void send(String message){
		System.out.println(message);
	}

	@Override
	public String toString() {
		return "Employee [name=" + name + ", age=" + age + "]";
	}
}
```

```
public class Test {
	public static void main(String[] args) throws ClassNotFoundException, InstantiationException, IllegalAccessException, NoSuchFieldException, SecurityException {

		System.out.println("------------反射机制获取类的三种方法---------------");
		Class<?> c1 = Class.forName("com.reflect.Employee"); // 注意全类名
		Class<?> c2 = Employee.class;
		Employee e = new Employee("lisan", 18, new int[]{12,13});
		Class<?> c3 = e.getClass();
		// 创建对象
		Object o = c1.newInstance();
		// 获取属性 ，分为所有的属性和指定的属性
		System.out.println("---------------获取全部属性---------------");
		Class<?> c = Class.forName("java.lang.Integer");
		Field[] fs = c.getDeclaredFields();
		StringBuffer sb = new StringBuffer();
		sb.append(Modifier.toString(c.getModifiers())+" class "+c.getSimpleName()+"{\n");
		for(Field field : fs){
			sb.append("\t");
			sb.append(Modifier.toString(field.getModifiers())+" ");  //获得属性的修饰符，例如public，static
			sb.append(field.getType().getSimpleName()+" ");  //属性的类型的名字
			sb.append(field.getName()+";\n");  //属性的名字+回车
		}
		sb.append("}");
		System.out.println(sb);
		System.out.println("---------------获取部分属性-----------------");
		Field nameF = c1.getDeclaredField("name");
		Field ageF = c1.getDeclaredField("age");
		Object oo = c1.newInstance();
		nameF.setAccessible(true); // 使用反射机制可以打破封装性，导致了java对象的属性不安全。
		ageF.setAccessible(true);  // 使用反射机制可以打破封装性，导致了java对象的属性不安全。
		nameF.set(oo, "lisan");  // 给oo对象的name属性赋值"lisan"
		ageF.set(oo,18);   // 给oo对象的age属性赋值"11"
		System.out.println(nameF.get(oo));  // 得到oo对象的name属性的值
		System.out.println(ageF.get(oo));   // 得到oo对象的age属性的值
	}
}
输出-->
------------反射机制获取类的三种方法---------------
---------------获取全部属性---------------
public final class Integer{
	public static final int MIN_VALUE;
	public static final int MAX_VALUE;
	public static final Class TYPE;
	static final char[] digits;
	static final char[] DigitTens;
	static final char[] DigitOnes;
	static final int[] sizeTable;
	private final int value;
	public static final int SIZE;
	private static final long serialVersionUID;
	static final boolean $assertionsDisabled;
}
---------------获取部分属性-----------------
lisan
18

```

```
public class TestReflect {
	public static void main(String[] args) throws ClassNotFoundException {
		Class<Employee> c1 = Employee.class;
		Class<?> c2 = Class.forName("com.reflect.Employee");
		// 获取类的修饰符
		int mod = c1.getModifiers();
		System.out.println(mod);
		System.out.println(Modifier.toString(mod));
		// 获得类全名
		String name = c1.getName();
		System.out.println(name);
		// 获得父类
		Class superClass = c1.getSuperclass();
		System.out.println(superClass);
		// 获取c1实现的接口
		Class[] interfaces = c1.getInterfaces();
		for (Class t : interfaces) {
			System.out.println("interfacesName = " + t.getName());
		}
		//获取指定类的成员变量
		System.out.println("-----------获取指定类的成员变量-----------");
		Field[] fields = c1.getDeclaredFields();
		for (Field field : fields) {
			String modifier = Modifier.toString(field.getModifiers());
			Class<?> type = field.getType();
			String name2 = field.getName();
			if(type.isArray()){
				String arrType = type.getComponentType().getName()+"[]";
				System.out.println(""+modifier+" "+arrType+" "+name2+";");
			}else{
				System.out.println(""+modifier+" "+type+" "+name2+";");
			}
		}
		// 获取类的构造方法
		System.out.println("------------获取类的构造方法--------------");
		Constructor[] constructors = c1.getDeclaredConstructors();
		for (Constructor constructor : constructors) {
			String name3 = constructor.getName(); //构造方法名
			String modi = Modifier.toString(constructor.getModifiers()); //获取访问修饰符
			System.out.print("" + modi +" " + name3 + "(");
			Class[] paramTypes = constructor.getParameterTypes(); //获取构造方法中的参数
		for (int i = 0; i < paramTypes.length; i++) {
			// 从第二个参数开始加符号
			if (i > 0) {
				System.out.print(",");
			}
			if (paramTypes[i].isArray()) {
				System.out.print(paramTypes[i].getComponentType().getName()+"[]");
			} else {
				System.out.print(paramTypes[i].getName());
			}
		}
		System.out.println(");");
		}

		// 获取成员方法
		System.out.println("---------获取成员方法----------");
		Method[] methods = c1.getDeclaredMethods();
		for (Method method : methods) {
			String modif = Modifier.toString(method.getModifiers());
			Class returnType = method.getReturnType();
			if(returnType.isArray()){
				String arrType = returnType.getComponentType().getName()+"[]";
				System.out.print(""+modif+" "+arrType+" "+method.getName()+"(");
			}else{
				System.out.print(""+modif+" "+returnType.getName()+" "+method.getName()+"(");
			}
			Class<?>[] paramTypes = method.getParameterTypes();
			for(int i=0;i<paramTypes.length;i++){
				if(i>0){
					System.out.print(",");
				}
				if(paramTypes[i].isArray()){
					System.out.print(paramTypes[i].getComponentType().getName()+"[]");
				}else{
					System.out.print(paramTypes[i].getName());
				}
			}
			System.out.println(");");
		}

		// java动态绑定
	}
}
输出--->
1
public
com.reflect.Employee
class java.lang.Object
interfacesName = java.lang.Cloneable
-----------获取指定类的成员变量-----------
private class java.lang.String name;
private int age;
private int[] arr;
------------获取类的构造方法--------------
public com.reflect.Employee();
public com.reflect.Employee(java.lang.String,int,int[]);
---------获取成员方法----------
public java.lang.String toString();
public java.lang.String getName();
public void setName(java.lang.String);
public int[] getArr();
public void setArr(int[]);
public void setAge(int);
public void send(java.lang.String);
public void display();
public int getAge();
```


