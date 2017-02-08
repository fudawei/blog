title: MyBatis学习笔记
date: 2016-06-09 22:40:46
categories: [数据库]
tags: [MyBatis]
---
### MyBatis 接触
configure.xml

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
"http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <typeAliases>
        <typeAlias alias="User" type="com.yihaomen.mybatis.model.User"/>
    </typeAliases>

    <environments default="development">
        <environment id="development">
        <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
            <property name="driver" value="com.mysql.jdbc.Driver"/>
            <property name="url" value="jdbc:mysql://127.0.0.1:3306/test" />
            <property name="username" value="root"/>
            <property name="password" value="root"/>
            </dataSource>
        </environment>
    </environments>

    <mappers>
        <mapper resource="com/yihaomen/mybatis/model/User.xml"/>
    </mappers>
</configuration>

user.xml

<mapper namespace="com.yihaomen.mybatis.models.UserMapper">
    <select id="selectUserByID" parameterType="int" resultType="User">
        select * from `user` where id = #{id}
    </select>
</mapper>


public class Test {
	private static SqlSessionFactory sqlSessionFactory;
	private static Reader reader;

	static {
		try {
			reader = Resources.getResourceAsReader("Configuration.xml");
			sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) {
		SqlSession session = sqlSessionFactory.openSession();
		try {
			User user = (User) session.selectOne(
					"com.yihaomen.mybatis.models.UserMapper.selectUserByID", 1);
			System.out.println(user.getUserAddress());
			System.out.println(user.getUserName());
		} finally {
			session.close();
		}
	}
}

### 使用接口实现
user.xml ,改变namespace的值，指向接口
<mapper namespace="com.yihaomen.mybatis.inter.IUserOperation">
    <select id="selectUserByID" parameterType="int" resultType="User">
        select * from `user` where id = #{id}
    </select>
</mapper>

public static void main(String[] args) {
		SqlSession session = sqlSessionFactory.openSession();
		try {
			IUserOperation userOperation = session.getMapper(IUserOperation.class);
			User user = userOperation.selectUserByID(1);
			System.out.println(user.getUserAddress());
			System.out.println(user.getUserName());
		} finally {
			session.close();
		}
	}

### mybatis实现数据的增删改查
一、 查找
User.xml 配置
<mapper namespace="com.yihaomen.mybatis.inter.IUserOperation">
    <select id="selectUserByID" parameterType="int" resultType="User">
        select * from `user` where id = #{id}
    </select>
    <resultMap type="User" id="resultListUser">
        <id column="id" property="id" />
        <result column="userName" property="userName" />
        <result column="userAge" property="userAge" />
        <result column="userAddress" property="userAddress" />
    </resultMap>
    <select id="selectUsers" parameterType="string" resultMap="resultListUser">
        select * from user where userName like #{userName}
    </select>
</mapper>

接口增加方法
public interface IUserOperation {
	public User selectUserByID(int id);
	public List<User> selectUsers(String userName);
}

测试类
	public static void main(String[] args) {
		Test testUser = new Test();
		testUser.getUserList("%");
	}

	public void getUserList(String userName){
		SqlSession session = sqlSessionFactory.openSession();
		try {
			IUserOperation userOperation = session
					.getMapper(IUserOperation.class);
			List<User> users = userOperation.selectUsers(userName);
			for (User user : users) {
				System.out.println(user.getId() + ":" + user.getUserName()
						+ ":" + user.getUserAddress());
			}
		} finally {
			session.close();
		}
	}

二、 增加
user.xml
<insert id="addUser" parameterType="User"
        useGeneratedKeys="true" keyProperty="id">
        insert into user(userName,userAge,userAddress)
             values(#{userName},#{userAge},#{userAddress})
</insert>

public interface IUserOperation {
	public User selectUserByID(int id);
	public List<User> selectUsers(String userName);
	public void addUser(User user);
}

public static void main(String[] args) {
		User user = new User();
		user.setUserAddress("人民广场");
		user.setUserName("飞鸟");
		user.setUserAge(20);
		SqlSession session = sqlSessionFactory.openSession();
		try {
			IUserOperation userOperation = session.getMapper(IUserOperation.class);
			userOperation.addUser(user);
			session.commit();
			System.out.println("id : "+user.getId());
		} catch (Exception e) {
			// TODO: handle exception
		}finally{
			session.close();
		}
	}

三、更新数据
<update id="updateUser" parameterType="User" >
        update user set userName=#{userName},userAge=#{userAge},userAddress=#{userAddress} where id=#{id}
</update>

public interface IUserOperation {
	public User selectUserByID(int id);
	public List<User> selectUsers(String userName);
	public void addUser(User user);
	public void updateUser(User user);
}

public static void main(String[] args) {
		SqlSession session = sqlSessionFactory.openSession();
		try {
			IUserOperation userOperation = session.getMapper(IUserOperation.class);
			User user = userOperation.selectUserByID(4);
			user.setUserAddress("hell");
			userOperation.updateUser(user);
			session.commit();
		} catch (Exception e) {
			// TODO: handle exception
		}finally{
			session.close();
		}
	}

四、删除数据
 <delete id="deleteUser" parameterType="int">
    	delete from user where id=#{id}
 </delete>

 public interface IUserOperation {
	public User selectUserByID(int id);
	public List<User> selectUsers(String userName);
	public void addUser(User user);
	public void updateUser(User user);
	public void deleteUser(int id);
}

public static void main(String[] args) {
		SqlSession session = sqlSessionFactory.openSession();
		try {
			IUserOperation userOperation = session.getMapper(IUserOperation.class);
			userOperation.deleteUser(4);
			session.commit();
		} catch (Exception e) {
			// TODO: handle exception
		}finally{
			session.close();
		}
	}
五、表关联
	别名：
	<typeAliases>
		<typeAlias alias="Article" type="com.yihaomen.mybatis.model.Article"/>
	</typeAliases>

	<resultMap id="resultUserArticleList" type="com.yihaomen.mybatis.model.Article">  // 写全类名，否则提示找不到类
    	<id property="id" column="aid"/>
    	<result property="title" column="title"/>
    	<result property="content" column="content"/>

    	<association property="user" javaType="User">
    		<id property="id" column="id"/>
    		<result property="userName" column="userName"/>
    		<result property="userAddress" column="userAddress"/>
    	</association>
    </resultMap>

    <select id="getUserArticles" parameterType="int" resultMap="resultUserArticleList">
       select user.id,user.userName,user.userAddress,article.id aid,article.title,article.content from user,article
              where user.id=article.userid and user.id=#{id}
    </select>

public class Article {
	private int id;
    private User user;
    private String title;
    private String content;
}

public interface IUserOperation {
	public User selectUserByID(int id);
	public List<User> selectUsers(String userName);
	public void addUser(User user);
	public void updateUser(User user);
	public void deleteUser(int id);
	public List<Article> getUserArticles(int id);
}

public void getUserArticles(int userid){
		SqlSession session = sqlSessionFactory.openSession();
		try {
			IUserOperation userOperation = session.getMapper(IUserOperation.class);
			List<Article> articles = userOperation.getUserArticles(userid);
			for (Article article : articles) {
				System.out.println(article.getTitle()+":"+article.getContent()+":"+article.getUser().getUserName()+":"
						+article.getUser().getUserAddress());
			}
		} catch (Exception e) {
		} finally{
			session.close();
		}
	}


