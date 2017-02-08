title: SpringMVC学习笔记
date: 2014-02-09 22:31:05
categories: [Java,JavaEE框架]
tags: [springMVC]
---
### SpringMVC
SpringMVC 使用@RequestMapping 注解为控制器指定可以处理哪些URL请求
在控制器的类定义及方法定义处都可标注
@RequestMapping
类定义处： 提供初步的请求映射信息，相对于WEB应用的根目录
方法处：提供进一步的细分映射信息。相对于类定义处的URL。若类定义处未标注@RequestMapping，则方法标记的URL相对于WEB应用的根目录
DispatcherServlet 截获请求后，就通过控制器上@RequestMapping 提供的映射信息确定请求所对应的处理方法

eg
	<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
		<property name="prefix" value="/WEB-INF/views/"></property>
		<property name="suffix" value=".jsp"></property>
	</bean>

<a href="springmvc/testRequestMapping">test requestMapping </a>

// 类定义处标记的@RequestMapping限定了处理器可以处理所有URI为 /spring的请求，它相对于WEB容器部署的根路径
@RequestMapping("/springmvc")
@Controller
public class SpringMVCTest {
	private static final String SUCCESS = "success";
	// 处理器类可以定义多个处理方法，处理来自 /springmvc的请求
	@RequestMapping("/testRequestMapping")
	public String testRequestMapping(){
		System.out.println("testRequest...");
		return SUCCESS;
	}
}

	<a href="springmvc/testRequestMethod">test requestMethod </a>

	<br>
	<a href="springmvc/testParamsAndHeaders?username=atguigu&age=10">test ParamsAndHeaders </a>
	<br>

	<a href="springmvc/test/mnxyv/abc">test AntPath </a>
	<br>

	<a href="springmvc/testParamsAndHeaders?username=atguigu&age=10">test ParamsAndHeaders </a>
	<br>

	<form action="springmvc/testRequestMethod" method="post">
		<input type="submit" value="submit">
	</form>
	<br>
	<a href="springmvc/testRequestMapping">test requestMapping </a>
	<br>
	<a href="helloworld">HelloWorld</a>

@Controller
public class HelloWorld {
	/**
	 * 1. 使用 @RequestMapping 注解来映射请求的url
	 * 2. 返回值会通过视图解析器解析为实际的物理视图
	 * 对于InternalResourceViewResolver视图解析器，做如下解析
	 * prefix+returnVal+suffix 这样的方式得到实际的物理视图
	 */
	@RequestMapping("/helloworld")
	public String hello() {
		System.out.println("hello world");
		return "success";
	}
}
-----------------------------------------------
RequestMapping 除了可以使用请求URL映射请求外，还可以使用请求方法，请求参数及请求头映射请求
RequestMapping 的value,method,params及headers分别表示请求URL，请求方法、请求参数及请求头的映射条件，他们之间是与的关系，联合使用多个条件可以让请求映射更加精确
params和headers支持简单的表达式：
param1: 表示请求必须包含名为param1的请求参数
!param1: 表示请求不能包含名为param1的请求参数
param1!=value1: 表示请求必须包含名为param1的请求参数，值不能为value1
{"param1=value","param2"} : 表示必须包含param1和param2，且param1的参数值必须为value

@RequestMapping("/springmvc")
@Controller
public class SpringMVCTest {
	private static final String SUCCESS = "success";
	// 指定接收POST的请求，页面可以设置为form表单
	@RequestMapping(value="/testRequestMethod",method=RequestMethod.POST)
	public String testRequestMethod(){
		System.out.println("testRequestMethod...");
		return SUCCESS;
	}
	// 必须包含username属性和age属性，且age不能为1，否则不予接收
	@RequestMapping(value="testParamsAndHeaders",params={"username","age!=1"})
	public String testParams(){
		System.out.println("testParamsAndHeaders...");
		return SUCCESS;
	}
	// 支持匹配符
	// ? 匹配文件名中的一个字符
	// * 匹配文件名中的任意字符
	// ** 匹配多层路径
	// 还支持Ant风格的URL
	@RequestMapping("/test/*/abc")
	public String testRequestMapping(){
		System.out.println("testRequest...");
		return SUCCESS;
	}
}


@PathVariable 映射URL绑定的占位符
带占位符的URL是SpringMVC向REST目标挺进发展具有里程碑的意义
通过@PathVariable 可以将URL中占位符参数绑定到控制器处理方法的入参中；URL 中的{xxx}占位符可以通过@PathVariable("xxx")绑定到操作方法的入参中
eg : <a href="springmvc/testPathVariable/1">test requestMapping </a>

// @PathVariable 可以映射URL中的占位符到目标方法的参数中 - REST风格
	@RequestMapping("/testPathVariable/{id}")
	public String testPathVariable(@PathVariable("id") Integer id){
		System.out.println("testPathVariable "+id);
		return SUCCESS;
	}

REST Representational State Transfer 资源表现层状态转化
具体的说就是HTTP协议里面，GET 用来获取资源，POST 用来新建资源，PUT 用来更新资源，DELETE 用来删除资源

form表单只支持GET与POST请求，Spring 使用 HiddenHttpMethodFilter 把这些请求转换为标准的http方法，使得支持GET,POST,PUT 与DELETE请求
把 HiddenHttpMethodFilter 配置到web.xml中，可以把post请求转为delete或post请求
1. 配置HiddenHttpMethodFilter
2. 发送post请求时，携带一个name="_method"的隐藏域，值为delete或put

Rest 风格
<form action="springmvc/testRest/1" method="post">
	<input type="hidden" name="_method" value="PUT">
	<input type="submit" value="PUT">
</form>

<br>
<form action="springmvc/testRest/1" method="post">
	<input type="hidden" name="_method" value="Delete">
	<input type="submit" value="test delete">
</form>
<br>

@RequestMapping(value="/testRest/{id}", method=RequestMethod.PUT)
	public String testRestPut(@PathVariable Integer id){
		System.out.println("Put: "+id);
		return SUCCESS;
	}

	@RequestMapping(value="/testRest/{id}", method=RequestMethod.DELETE)
	public String testRestDelete(@PathVariable Integer id){
		System.out.println("Delete: "+id);
		return SUCCESS;
	}

web.xml
```
<filter>
  	<filter-name>HiddenHttpMethodFilter</filter-name>
  	// 配置HiddenHttpMethodFilter 可以把POST请求转换为DELETE或POST请求
  	<filter-class>org.springframework.web.filter.HiddenHttpMethodFilter</filter-class>
  </filter>
  <filter-mapping>
  	<filter-name>HiddenHttpMethodFilter</filter-name>
  	<url-pattern>'/*'</url-pattern>
  </filter-mapping>

  <servlet>
    <servlet-name>springDispatcherServlet</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
      <param-name>contextConfigLocation</param-name>
      <param-value>classpath:springmvc.xml</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
  </servlet>
  <servlet-mapping>
    <servlet-name>springDispatcherServlet</servlet-name>
    <url-pattern>/</url-pattern>
  </servlet-mapping>
```
在springMVC中得到id,使用 @PathVariable 注解

Spring MVC 通过分析处理方法的签名，将HTTP请求信息绑定到处理方法的相应入参中。
必要时可以对方法及方法入参标注相应的注解(@PathVariable,@RequestParam,@RequestHeader 等)，Spring MVC 框架会将HTTP请求的信息绑定到相应的方法入参中，并根据方法的返回值类型做出相应的后续处理

eg:
<a href="springmvc/testRequestParam?username=haha&age=10">Test RequestParam</a>
/**
 * [testRequestParam description]
 * @RequestParam 映射请求参数
 *  value 值即请求参数的参数名
 *  required 该参数是否必须，默认为true
 *   defaultValue 请求参数的默认值
 */
@RequestMapping(value="/testRequestParam")
	public String testRequestParam(@RequestParam(value="username") String un,
			// (value="age", required=false, defaultValue="0") int age)
			@RequestParam(value="age", required=false) Integer age){   // 若某个值不是必须的，可以使用required=false注解
		System.out.println("username =　" + un + "; age = "+age);
		return SUCCESS;
	}
------------------
<a href="springmvc/testRequestHeader">Test RequestHeader</a>

@RequestMapping("/testRequestHeader")
	public String testRequestHeader(@RequestHeader(value="Accept-Language") String al){
		System.out.println("testRequestHeader,Accept-Language : "+al);
		return SUCCESS;
	}

----------------------
使用 @CookieValue 取得Cookie值，映射一个Cookie值，属性同@RequestParam
@RequestMapping("/testCookievalue")
	public String testCookieValue(@CookieValue("JSESSIONID") String sessionId){
		System.out.println("testCookieValue:sessionId "+sessionId);
		return SUCCESS;
	}

使用POJO对象绑定请求参数值
SpringMVC 会按请求参数名和POJO属性名进行自动匹配，自动为该对象填充属性值，支持级联属性，如dept.deptId, dept.address.tel 等

<form action="springmvc/testPojo" method="post">
		username:<input type="text" name="username">
		<br>
		password:<input type="password" name="password">
		<br>
		email:<input type="text" name="email">
		<br>
		age:<input type="text" name="age">
		<br>
		city:<input type="text" name="address.city">
		<br>
		province:<input type="text" name="address.province">
		<br><br>
		<input type="submit" value="submit">
	</form>

public class User {
	private String username;
	private String password;
	private String email;
	private int age;
	private Address address;
	getter...setter ...
}
@RequestMapping("/testPojo")
	public String testPojo(User user){
		System.out.println("testPojo "+user);
		return SUCCESS;
	}

MVC 的Handler方法可以接受哪些ServletAPI类型的参数
HttpServletRequest HttpServletResponse HttpSession java.security.Principal Locale InputStream OutputStream Reader Writer

Spring MVC 提供了一下几种途径输出模型数据：
ModelAndView：处理方法返回值类型为ModelAndView时，方法体即可通过该对象添加模型数据
Map 及 Model:入参为 org.springframework.ui.Model 、 org.springframework.ui.ModelMap 或 java.util.Map 时，处理方法返回时，Map 中的数据会自动添加到模型中
@SessionAttributes:将模型中的某个属性暂存到HttpSession中，以便多个请求之间可以共享这个属性
@ModelAttribute:方法入参标注该注解后，入参的对象就会放到数据模型中

控制器处理方法的返回值如果为ModelAndView，则其既包含视图信息，也包含模型数据信息
添加模型数据：
ModelAndView addObject(String attributeName,Object attributeValue)
ModelAndView addAllObject(Map<String,?> modelMap)
设置视图：
void setView(View view)
void setViewName(String viewName)

/**
 * 目标方法的返回值可以是ModelAndView类型
 * 其中可以包含视图和模型信息
 * Spring MVC 会把ModelAndView的model中数据放入到request域对象中
 * @return [description]
 */
@RequestMapping("/testModelAndView")
	public ModelAndView testModelAndView(){
		String viewName = SUCCESS;
		ModelAndView modelAndView = new ModelAndView(viewName);
		modelAndView.addObject("time",new Date());
		return modelAndView;
	}

<body>
	<h4>Success Page</h4>
	time: ${requestScope.time}
</body>

-------------------------
@RequestMapping("/testMap")
	public String testMap(Map<String,Object> map){
		map.put("name",Arrays.asList("tom","jerry","Mike"));
		return SUCCESS;
	}

Name: ${requestScope.name } 取得map模型数据

-----------------
若希望在多个请求之间公用某个模型属性数据，可以在控制器上标注一个 @SessionAttributes，Spring MVC 将在模型中对应的属性暂存到 HttpSession 中的数据会自动添加到模型中
@SessionAttributes 除了可以通过属性名指定需要放到会话中的属性外（使用value属性值），还可以通过模型属性的对象类型指定哪些模型属性需要放到会话中（使用types属性值）。** 注意：该注解只能放在类的上面不能放在方法上面 **
@SessionAttributes(type=User.class) 会将隐含模型中所有类型为User.class的属性添加到会话中
@SessionAttributes(value={"user1","user2"})
@SessionAttributes(types={User.class,Dept.class})
@SessionAttributes(value={"user1","user2"},types={Dept.class})

在已有基础上添加 @SessionAttributes({"user"})
@RequestMapping("testSessionAttributes")
	public String testSessionAttributes(Map<String,Object> map){
		User user = new User("Tom", "123456", "tom@gmail.com", 16);
		map.put("user", user);
		return SUCCESS;
	}

requestUser : ${requestScope.user }
sessionUser:${sessionScope.user }

若注解改为  @SessionAttributes(value={"user"},types=String.class)  则
@RequestMapping("testSessionAttributes")
	public String testSessionAttributes(Map<String,Object> map){
		User user = new User("Tom", "123456", "tom@gmail.com", 16);
		map.put("user", user);
		map.put("school","atguigu");
		return SUCCESS;
	}
	也会把school放入到request和session中

ModelAttribute
	<!--
		1. 原始数据  1,Tom,123456,tom@atguigu.com,12
		2. 密码不能修改
		3. 表单回显，模拟操作直接在表单填写对应的属性值
	 -->
	<form action="springmvc/testModelAttribute">
		<input type="hidden" name="id" value=1>
		username:<input type="text" name="username" value="Tom">
		<br>
		email:<input type="text" name="email" value="tom@atguigu.com">
		<br>
		age:<input type="text" name="age" value="12">
		<br>
		<input type="submit" value="submit">
	</form>

	/*
	 * 有 @ModelAttribute标记的方法，会在每个目标方法执行之前被SpringMVC调用
	 */
	@ModelAttribute
	public void getUser(@RequestParam(value="id",required=false) Integer id,
			Map<String,Object> map){
		if(id!=null){
			User user = new User(1,"Tom","1256","tom@atguigu.com",12);
			System.out.println(" 从数据库获取一个对象 "+user);
			map.put("user",user);
		}
	}
	/*
	 * 1. 执行@ModelAttribute注解修饰的方法，从数据库中取出对象，把对象放入到了Map中，键为 user
	 * 2. SpringMVC 从Map中取出User对象，并把表单的请求参数赋给该User对象的对应属性
	 * 3. SpringMVC 把上述对象传入目标方法的参数
	 * 注意： 在ModelAttribute修饰的方法中，放入到Map时的键需要和目标方法入参类型的第一个字母小写的字符串一致，即必须是 user
	 */
	@RequestMapping("/testModelAttribute")
	public String testModelAttribute(User user){
		System.out.println("modify "+user);
		return SUCCESS;
	}
可以用@ModelAttribute 注释方法参数或方法。带有@ModelAttribute 注解的方法会将其要输入的或创建的参数对象添加到Model对象中（若方法没有显示添加）
SpringMVC 确定目标方法POJO类型入参的过程
1. 确定一个key
1)若目标方法的POJO类型的参数木有使用@ModelAttribute 作为修饰，则key为POJO类型第一个字母的小写
2)若使用了@ModelAttribute 来修饰，则key为@ModelAttribute 注解的value属性值
2. 在implicitModel 中查找key对应的对象，若存在，则作为入参传入
若在@ModelAttribute 标记的方法中在Map中保存过，则key和1确定的key一致，则会获取到
3.若implicitModel中不存在key对应的对象，则检查当前的Handler是否使用@SessionAttribute 注解修饰，若使用了该注解，且@SessionAttributes 注解的value属性值中包含了key，则会从HttpSession中来获取key所对应的value值，若存在则直接传入到目标方法的入参中，若不存在则将抛异常
4. 若Handler没有标记@SessionAttributes 注解或@SessionAttributes 注解的value值不包含key，则会通过反射来创建POJO类型的参数，传入为目标方法的参数
5. SpringMVC 会把key和POJO类型的对象保存在impliciModel中，进而会保存到request中

SpringMVC 视图解析流程分析
请求处理方法完成后，最终赶回一个ModelAndView对象，对于那些返回String,View 或ModelMap等类型的处理方法，Spring MVC 也会在内部将他们装配成一个ModelAndView对象，包含了逻辑名和模型对象的视图
Spring MVC 借助视图解析器（ViewResolver）得到最终的视图对象，最终的视图可以是JSP，也可能是Excel、JFreeChart 等各种表现形式的视图
视图的作用是渲染模型数据，将模型的数据以某种形式呈现给客户
为了实现视图模型和具体实现技术的解耦，Spring 在org.springframework.web.servlet 包中定义了一个高度抽象的View接口
视图对象由视图解析器负责实例化，由于视图是无状态的，所有他们不会有线程安全的问题

InternalResourceViewResolver JSP 是最常见的视图技术，可以使用InternalResourceViewResolver作为视图解析器
若项目中使用了JSTL，则SpringMVC会自动把视图

<mvc:view-controller path="/success" view-name="success">
<mvc:annotation-driven></mvc:annotation-driven>

若希望使用Excel展示数据列表，仅需要扩展SpringMVC提供的AbstractExcelView或AbstractJExcel View 即可。实现buildExcelDocument()方法，在方法中使用模型数据构建Excel文档就可以了
视图对象需要配置IOC容器中的一个bean，使用BeanNameViewResolver作为视图解析器即可
若希望直接在浏览器中直接下载Excel文档，则可以设置响应头 Content-Disposition 的值为attachment;filename=xxx.xls

自定义视图
配置xml
<!-- 扫描包 -->
	<context:component-scan base-package="com.atguigu.springmvc"></context:component-scan>

	<!-- 配置视图解析器，如何把handler方法返回值解析为实际的物理视图 -->
	<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
		<property name="prefix" value="/WEB-INF/views/"></property>
		<property name="suffix" value=".jsp"></property>
	</bean>

	<!-- 配置BeanNameViewResolver视图解析器;使用视图的名字来解析视图 -->
	<!-- 通过order属性定义视图的优先级，order值越小视图解析器优先级越高。
	InternalResourceViewResolver 优先级数值最大，所有优先级最低-->
	<bean class="org.springframework.web.servlet.view.BeanNameViewResolver">
		<property name="order" value="100"></property>
	</bean>

@RequestMapping("/testView")
	public String testView(){
		System.out.println("test view");
		return "helloView";
	}

@Component
public class HelloView implements View{

	@Override
	public String getContentType() {
		return "text/html";
	}

	@Override
	public void render(Map<String, ?> arg0, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		response.getWriter().print("hello view time:"+new Date());
	}

}

重定向
@RequestMapping("/testRedirect")
	public String testRedirect(){
		System.out.println("testRedirect");
		return "redirect:/index.jsp";  // 重定向到根目录的页面，
	}
重定向和Flash属性
转发比重定向快，因为重定向经过客户端，而转发没有。但是，有时采用重定向更好，若需要重定向到一个外部网站，则无法使用转发
使用重定向的一个不方便的地方是：无法轻松的传值给目标页面，而采用转发，则可以简单的将属性添加到model中。Spring 3 版本通过Flash属性提供了一种供重定向传值的方法
要使用Flash属性，必须在Spring MVC 配置文件中有一个<annotation-driver/> 元素，然后还必须在方法参数里面添加一个新的参数u类型
org.springframework.web.servlet.mvc.support.RedirectAttributes
@RequestMapping(value="product-save",method=RequestMethod.POST)
public String saveProduct(ProductForm productForm, RedirectAttributes redirectAttributes){
	redirectAttributes.addFlashAttribute("message","The product was successfully added");
	return "redict:/product_view" + product.getId();
}

### tomcat默认就是不允许PUT和DELETE的
如何配置Tomcat支持HTTP Delete和Put 方法
在tomcat web.xml文件中配置org.apache.catalina.servlets.DefaultServlet的
<init-param>
	<param-name>readonly</param-name>
	<param-value>false</param-value>
</init-param>
readonly参数默认是true，即不允许delete和put操作，所以通过XMLHttpRequest对象的put或者delete方法访问就会报告http 403错误。为REST服务起见，应该设置该属性为false。

Jstl 学习
页面请求：　<a href="emps">List All Employees</a>
Handler 处理
@RequestMapping("/emps")
	public String list(Map<String, Object> map){
		// 把结果放入到employees这个map中，返回
		map.put("employees", employeeDao.getAll());
		return "list";
	}
list.jsp
<br> 我是分割线<br>
	<c:if test="${empty requestScope.employees }">
		没有任何员工信息
	</c:if>
	<c:if test="${!empty requestScope.employees }">
		<table border="1" cellpadding="10" cellspacing="1">
			<tr>
				<th>ID</th>
				<th>LastName</th>
				<th>Email</th>
				<th>Gender</th>
				<th>Department</th>
				<th>Edit</th>
				<th>Delete</th>
			</tr>
			<c:forEach items="${requestScope.employees }" var="emp">
				<tr>
					<td>${emp.id }</td>
					<td>${emp.lastName }</td>
					<td>${emp.email }</td>
					<td>${emp.gender==0?'Female' : 'Male' }</td>
					<td>${emp.department.departmentName }</td>
					<td><a href="">Edit</a></td>
					<td><a href="">Delete</a></td>
				</tr>
			</c:forEach>
		</table>
	</c:if>

可以在spring MVC 中配置 <mvc:default-servlet-handler/> 可以解决静态资源文件找不到的问题

xml配置文件可以通过一份主配置文件，其它文件导入



应用MVC，可以在Controller类中调用后端业务逻辑，通常，需要若干封装了后端复杂逻辑的Service类，在Service类中，可以实例化一个DAO类来访问数据库。在Spring MVC 中，Service 对象可以自动被注入到Controller对象中，而DAO对象可以自动被注入到Service对象中。
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${requestScope.errors !=null}">
	<p id="errors">
	Errors(s)!
	<ul>
	<c:foreach var="errors" items="${requestScope.errors}">
		<li>${error}</li>
	</c:foreach>
	</ul>
	</p>
</c:if>

一般的， @RequestMapping("/custom") 和 @RequestMapping(value="/custom") 一样，如果有超过一个属性时，必须写入value属性名称
method属性用来指示该方法处理哪些HTTP方法 eg: RequestMethod.PUT

import org.apache.commons.logging.Log ;
import org.apache.commons.logging.LogFactory;
private static final Log logger = LogFactory.getLog(Product.class)
logger.info("save product");

---------------------------------------------
### 编写转换器 && 验证器
一. 转换器
1. 实现Converter<S,T> 接口，S 输入，T输出；
	eg: 编写StringToDateConverter
2. 注册转换器
	<bean id="conversionService" class="org.springframework.context.support.ConversionServiceFactoryBean">
    	<property name="converters">
    		<list>
    			<bean class="com.yuchuan.controller.StringToDateConverter">
    				<constructor-arg type="java.lang.String" value="MM-dd-yyyy" ></constructor-arg>
    			</bean>
    		</list>
    	</property>
    </bean>

    <mvc:annotation-driven conversion-service="conversionService"/>
3. 编写控制类调用
	@RequestMapping(value="employee_save")
	public String saveEmployee(@ModelAttribute Employee employee,
			BindingResult bindingResult,Model model){
		if(bindingResult.hasErrors()){
			FieldError fieldError = bindingResult.getFieldError();
			logger.info("Code:"+fieldError.getCode()+",field:"+fieldError.getField());
			return "EmployeeForm";
		}
		logger.info("employeeDeatails");
		model.addAttribute("employee",employee);
		return "EmployeeDetails";
	}
每个需要校验的Bean后面紧跟一个BindingResult，SpringMVC框架会将校验结果保存在它里面，通过hasErrors方法可以
判断是否有校验错误；最后，当返回到原页面以后，SpringMVC框架还会将所有校验错误信息保存在上下文中，供页面上取得
校验错误，Spring提供了一套JSP自定义标签。

注意引入css文件 <style type="text/css">@import url("<c:url value="/css/main.css"/>");</style>
不经过springmvc默认拦截器
	<mvc:annotation-driven/>
    <mvc:resources mapping="/css/**" location="/css/"/>
    <mvc:resources mapping="/*.html" location="/"/>


二、 验证器
1. 编写ProductValidator，实现Validator接口
2. xml文件
	<bean id="messageSource" class="org.springframework.context.support.ReloadableResourceBundleMessageSource">
    	<property name="basename" value="/WEB-INF/resource/messages"></property>
    </bean>
3. 编写Controller
@RequestMapping("/product_save")
	public String saveProduct(@ModelAttribute Product product,
			BindingResult bindingResult,Model model){
		ProductValidator productValidator = new ProductValidator();
		productValidator.validate(product, bindingResult);
		if(bindingResult.hasErrors()){
			FieldError fieldError = bindingResult.getFieldError();
			logger.info("Code:"+fieldError.getCode()+",field:"+fieldError.getField());
			return "ProductForm";
		}
		model.addAttribute("product",product);
		return "ProductDetails";
	}

JSTL
遍历对象
<c:forEach items="${books}" var="book">
    <tr>
        <td>${book.category.name}</td>
        <td>${book.title}</td>
        <td>${book.isbn}</td>
        <td>${book.author}</td>
    </tr>
</c:forEach>

遍历 HashMap<String,String>
<c:forEach items="${requestScope.capitals }" var="map">
    	<tr>
    		<td>${map.key }</td>
    		<td>${map.value }</td>
    	</tr>
    </c:forEach>

遍历 HashMap<String,String[]>
<c:forEach items="${requestScope.bigCities}" var="mapItem">
    <tr>
        <td>${mapItem.key}</td>
        <td>
            <c:forEach items="${mapItem.value}" var="city"
                        varStatus="status">
                ${city}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        </td>
    </tr>
    </c:forEach>

遍历以特殊符号分割的字符串
    <c:forTokens items="Ab,Ba,BC" delims="," var="item">
            	<c:out value="${item}"></c:out>
    </c:forTokens>

<fmt:formatNumber value="12" type="number"></fmt:formatNumber>
<fmt:formatNumber value="12" type="number" minIntegerDigits="3"></fmt:formatNumber>
<fmt:formatNumber value="123434" pattern=".000"></fmt:formatNumber>
<fmt:formatNumber value="12" type="currency"></fmt:formatNumber>
<fmt:formatNumber value="0.12" type="percent"></fmt:formatNumber>
<fmt:formatNumber value="0.125" type="percent" minFractionDigits="2"></fmt:formatNumber>

使用上传文件（使用commons-fileupload和commons-io）
@RequestMapping(value = "/product_save")
    public String saveProduct(HttpServletRequest servletRequest,
            @ModelAttribute Product product, BindingResult bindingResult,
            Model model) {

        List<MultipartFile> files = product.getImages();

        List<String> fileNames = new ArrayList<String>();
        File imageFile = null;
        if (null != files && files.size() > 0) {
            for (MultipartFile multipartFile : files) {

                String fileName = multipartFile.getOriginalFilename();
                fileNames.add(fileName);

                imageFile = new File(servletRequest.getServletContext()
                        .getRealPath("/image"), fileName);
                logger.info("path is :" + imageFile);
                try {
                    multipartFile.transferTo(imageFile);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        // save product here
        model.addAttribute("product", product);
        model.addAttribute("path",imageFile);
        return "ProductDetails";
    }

JSP
<c:forEach items="${product.images}" var="image">
            <li>${image.originalFilename}
            <img src="${path }"/>
            </li>
        </c:forEach>
配置
<bean id="multipartResolver"
            class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
        <property name="maxUploadSize" value="2000000"/>
    </bean>


Servlet 注意线程安全性。Servlet 实例会被一个应用程序中的所有用户共享，因此不建议使用类级变量，除非它们是只读的，或者是java.util.concurrent.atomic 包的成员
将项目打包成war文件复制放在Tomcat的webapps目录下，当开始启动Tomcat时，Tomcat 就会自动解压这个war文件，部署成war文件所有Servlet容器中都适用

ServletRequest 方法
public int getContentLength()
public String getContentType()
public Stirng getProtocol()
public String getParameter(Stirng name)
还可以使用getParameterNames/getParameterMap/getParameterValues 获取表单域名、值及查询字符串。

ServletResponse
在调用Servlet的Service方法前，Servlet 容器首先创建一个ServletResponse，并将它作为第二个参数传给Service方法。ServletResponse 隐藏了向浏览器发送响应的复杂过程 。在ServletResponse中定义的方法之一是getWritter方法，它返回了一个可以向客户端发送文本的PrintWriter.还有一个方法可以用来向浏览器发送输出，getOutputStream,但这个方法是用于发送二进制数据，因此大部分情况下使用的是getWriter,而不是getOutputStream.
ServletConfig
当Servlet容器初始化Servlet时，Servlet 容器会给Servlet的init方法传入一个ServletConfig.ServletConfig 封装可以通过@Webservlet 或者部署描述符（web.xml）传给Servlet配置信息。这样传入的每一个条信息就叫一个初始参数。一个初始参数有key和value两个元件。
为了从servlet内部获取到初始参数的值，要在Servlet容器传给Servlet的init方法的ServletConfig中调用getInitParameter方法。
String getInitParameter(String name) 此外，getInitParameterNames方法则是返回所有参数名称的一个Enumeration。
除了getInitParameter和getInitParameterNames，ServletConfig 还提供了 getServletContext 方法。
@WebServlet(name="MyServlet",
	urlPatterns={"/my"},
	initParams={
			@WebInitParam(name="admin",value="Harry"),
			@WebInitParam(name="email",value="admin@example.com")
	})
public class MyServlet implements Servlet{
	public void service(ServletRequest request, ServletResponse response){
		String admin = servletConfig.getInitParameter("admin");
		String email = servletConfig.getInitParameter("email");
	}
}

ServletContext
可以共享从应用程序中的所有资料处访问到的信息 ，并且可以动态注册web对象，前者将对象保存在ServletContext中的一个内部Map中
Object getAttribute(String name)
java.util.Enumeration<Stirng> getAttributeNames()
void setAttribute(String name,Object object)
void remove Attribute(String name)

GenericServlet
public void service(ServletRequest paramServletRequest, ServletResponse paramServletResponse)
			throws ServletException, IOException {
		ServletConfig servletConfig = getServletConfig();
		String admin = servletConfig.getInitParameter("admin");
		paramServletResponse.setContentType("text/html");
		PrintWriter writer = paramServletResponse.getWriter();
		writer.println("<html><head></head>"
				+"<body>Hello From " + admin
				+"</body></html>");
	}

HttpServlet
查阅HttpServlet 中service方法源码，该方法会检验用来发送请求的HTTP方法（通过调用request.getMethod）并调用以下方法之一：doGet/doPost/doHead/doPut/doDelete/doTrace/doOptions。这七种方法每一种方法都表示一个HTTP方法
![javax.servlet主要类型](http://7xrkr6.com1.z0.glb.clouddn.com/16-6-5/85130786.jpg)
![javax.servlet.http主要类型](http://7xrkr6.com1.z0.glb.clouddn.com/16-6-5/57507735.jpg)

Servlet 上的WebServlet标注如果如果同时也在部署描述符中进行声明，那么它将不起作用。但是，在有部署描述符的应用程序中，却不在部署描述符中标注的Servlet时，则仍然有效。这意味着，可以标注Servlet，并在同一个应用程序的部署描述符中声明这些Servlet
Filter 配置eg:
<filter>
	<filter-name>Logging Filter</filter-name>
	<filter-class>com.yuchuan.LoggingFilter</filter-class>
</filter>
<filter-mapping>
	<filter-name>Logging Filter</filter-name>
	<url-pattern>MyServlet</url-pattern>
</filter-mapping>

Listener 用来注册一个监听器，子元素listener-class包含监听器类的全路径名
<listener>
	<listener-class>com.yuchuan.ApplicationListener</listener-class>
</listener>

servlet-mapping
映射一个Servlet到/first
<servlet>
	<servlet-name>FirstServlet</servlet-name>
	<servlet-class>com.yuchuan.FirstServlet</servlet-class>
</servlet>
<servlet-mapping>
	<servlet-name>FirstServlet</servlet-name>
	<url-pattern>/first</url-pattern>
</servlet-mapping>

session-config 元素定义了javax.servlet.http.HttpSession 实例的参数，此元素可以包含session-timeout cookie-config或 tracking-mode
session-timeout 指定会话时间超时间隔（分钟），必须为整数。如果该值为零或负数，则会话永不超时
cookie-config 定义了跟踪会话创建的cookie的配置
tracking-mode  定义了跟踪会话模式，有效值是 Cookie URL 或 SSl
eg: 表示应用的HttpSession对象在不活动12min后失效。
 	<session-config>
  		<session-timeout>12</session-timeout>
 	</session-config>

xsi:schemaLocation 属性制定了模式文档的位置，以便可以进行验证。

@RequestMapping(value="/url")
public String myMethod(){
	session.addAttribute(key,value);
}
Spring MVC 中可以在请求处理方法中出现的参数类型包括：
javax.servlet.ServletRequest 或 javax.servlet.http.HttpServletRequest
javax.servlet.ServletResponse 或 javax.servlet.http.HttpServletResponse
javax.servlet.HttpSession
org.springframework.web.context.request.WebRequest
java.util.Locale
java.io.InputStream 或  java.io.Reader
java.io.OutputStream 或 java.io.Writer
java.security.Principal
HttpEntity<?>
java.util.Map / org.springframework.ui.Model
org.springframework.web.servlet.mvc.support.RedirectAttributes
org.springframework.validation.Errors
org.springframework.validation.BindingResult
org.springframework.web.bind.support.SessionStatus
org.springframework.web.util.UriComponentsBuilder
带@PathVariable, @MatrixVariable 注解的对象
@RequestParam @RequestHeader @RequestBody @RequestPart
注意： org.springframework.ui.Model 类型，这不是一个Servlet API 类型，而是一个包含Map的Spring MVC 类型。每次调用请求处理方法时，Spring MVC 都创建Model对象并将其Map注入到各种对象
请求处理方法可以返回如下类型的对象：
ModelAndView
Model
Map 包含模型的属性
View
代表逻辑视图名的String
提供对Servlet的访问，以响应Http头部和内容 HttpEntity 或 ResponseEntity 对象
Callable
DeferredResult
其他任意类型，Spring 将其视作输出给View的对象模型

<mvc:annotation-driven/>
<mvc:resources mapping="/css/**" location="/css/"/>
<mvc:resources mapping="/*.html" location="/"/>
<annotation-driven/> 元素做的事情包括注册用于支持基于注解的控制器的请求处理方法的bean对象。<resource/> 元素则只是Spring MVC 哪些静态资源需要单独处理（不通过dispatcher servlet）
第一个确保在CSS目录下的所有文件可见，第二个允许显示所有的.html文件
注意： 如果没有 <annotation-driven /> <resources/>元素会阻止任意控制器被调用，若不需要使用resources,则不需要<annotation-driven/>元素

无论是否会使用Model，Spring MVC 都会在每一个请求处理方法被调用时创建一个Model实例，用于增加需要显示在视图中的属性。例如通过
model.addAttribute("product",product) 来添加实例 。


