title: Guava库学习
date: 2014-06-09 22:26:17
categories: [Java,Java工具库]
tags: [Guava,Java工具库]
---
Guava库学习
### Junit使用
> 在InteliJ中，test目录右键，Mark Directory as -> Test Source Root 然后在里面@Test引入Junit.jar即可编写测试用例
### 文件操作
 * 使用Files类来执行那些基本的任务，比如：移动或复制文件，或读取文件内容到一个字符串集合

 * Closer类，提供了一种非常干净的方式，确保Closeable实例被正确的关闭

 * ByteSource 和 CharSource类，提供了不可变的输入流（Input）和读（Reader）

 * ByteSink 和 CharSink类，提供了不可变的输出流（Output）和写（Writer）

 * CharStreams和ByteStreams类，为读Readers、写Writers、输入流InputStreams、输出流OutputStreams 提供了一些静态的实用方法

 * BaseEncoding类，提供了编码和解码字节序列和ASCII字符的方法

##### 文件的复制
```
@Test
    public void testFile() throws IOException {
        File original = new File("D:\\test.txt");
        File copy = new File("D:\\test3.txt");
        Files.move(original,copy);
    }
```
##### 文件的移动/重命名
```
@Test
    public void readFileIntoListOfStirngTest() throws IOException {
        File file = new File("D:\\test3.txt");
        List<String> expectedLines = Lists.newArrayList("hello one","two Hello","hello three");
        List<String> readLine = Files.readLines(file,Charsets.UTF_8);
        assertThat(expectedLines, is(readLine));
    }
```

##### 像字符串一样处理文件
```
实现LineProcessor接口，此处采用集合泛型
public class ToListLineProcessor implements LineProcessor<List<String>> {
    private static final Splitter splitter = Splitter.on(",");
    private List<String> bookTitle = Lists.newArrayList();
    private static final int TITLE_INDEX = 1;
    // 文件的每一行都会经过processLine处理
    @Override
    public boolean processLine(String line) throws IOException {
        bookTitle.add(Iterables.get(splitter.split(line),TITLE_INDEX));
        return true;
    }
    // 最终返回的结果
    @Override
    public List<String> getResult() {
        return bookTitle;
    }
}

@Test
    public void readLinesWithProcessors() throws IOException {
        File file = new File("D:\\test3.txt");
        List<String> readLines = Files.readLines(file, Charsets.UTF_8,new ToListLineProcessor());
        List<String> expectedLines = Lists.newArrayList("hello","world","hello");
        assertThat(expectedLines,is(readLines));
    }
```
##### 文件的哈希值
```
@Test
    public void testFilesHashing() throws IOException {
        File file = new File("D:\\test3.txt");
        HashCode hashCode = Files.hash(file, Hashing.md5());
        System.out.println(hashCode.toString().length());
    }
```
##### 文件写和追加数据
```
@Test
    public void appendingWritingFileTest() throws IOException {
        File file = new File("D:\\hello.txt");
        file.deleteOnExit();
        String hamletQuoteStart = "To be ,or not to be";
        Files.write(hamletQuoteStart, file, Charsets.UTF_8);
        String hamletQuoteEnd = ",that is the question";
        Files.append(hamletQuoteEnd, file, Charsets.UTF_8);
        assertThat(Files.toString(file, Charsets.UTF_8),is(hamletQuoteStart+hamletQuoteEnd));

        String overWrites = "OverWriting the file";
        Files.write(overWrites, file, Charsets.UTF_8);
        assertThat(Files.toString(file, Charsets.UTF_8), is(overWrites));

    }
```
我们可以通过Files类提供的静态工厂方法来创建ByteSource、ByteSink、 CharSource、CharSink实例
我们将专注于ByteSource和ByteSink对象，CharSource和 CharSink对象与之相似，只是使用的是字符
ByteSource类表示一个可读的字节
```
@Test
    public void createByteSourceFromFileTest() throws IOException {
        File f1 = new File("D:\\test2.txt");
        ByteSource byteSource = Files.asByteSource(f1);
        byte[] readByte = byteSource.read();
        assertThat(readByte,is(Files.toByteArray(f1)));
    }
```
ByteSink类表示一个可写的字节
```
@Test
    public void testCreateFileByteSink() throws IOException {
        File dest = new File("D:\\test.txt");
        ByteSink byteSink = Files.asByteSink(dest);
        File file = new File("D:\\test2.txt");
        byteSink.write(Files.toByteArray(file));
        assertThat(Files.toByteArray(dest), is(Files.toByteArray(file)));

    }
```

```
@Test
    public void copyToByteSinkTest() throws IOException {
        File source = new File("D:\\test.txt");
        File dest = new File("D:\\test2.txt");
        ByteSource byteSource = Files.asByteSource(source);
        ByteSink byteSink = Files.asByteSink(dest);
        byteSource.copyTo(byteSink);
        assertThat(Files.toByteArray(dest), is(Files.toByteArray(source)));
```

ByteStreams是一个实用的程序类，用来处理InputStream和OutputStream实例，CharStreams则是用来处理Reader和Writer实例的程序类。

### Strings类和Charsets类
###### Charsets类
```

@Test
    public void testCharsets(){
        print(Charsets.UTF_8);
        print(Charsets.ISO_8859_1);
        byte[] bytes;
        try {
            bytes = string.getBytes("UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        // Charsets类则包装了一些常用的 字符集常量，
        // 使用Charsets封装的字符集避免处理异常
        bytes = string.getBytes(Charsets.UTF_8);
    }
```
##### Strings类
```
@Test
    public void testString(){
        char c = 's';
        // 将param1的长度改变为length，长度不足的话向后追加字符param2
        print(Strings.padEnd(string,6,c));
        // 也有padStart()方法，向前追加，长度超出默认返回原字符
        print(Strings.padStart(string,6,c));
        print(Strings.nullToEmpty(null));
        print(Strings.emptyToNull(" "));
        print(Strings.isNullOrEmpty(null));
        print(Strings.repeat(string,3));
        // 返回两个字符串相同的前缀
        print(Strings.commonPrefix("nihaoma?","nibuhaoma?"));
        // 返回两个字符串相同的后缀
        print(Strings.commonSuffix("nihaoma?","nibuhaoma?"));

    }

```
### ComparisonChain类的学习和使用
```
public class Girl implements Comparable<Girl>{
    private String name;
    private double height;
    private String face;

    public Girl(String face, double height, String name) {
        this.face = face;
        this.height = height;
        this.name = name;
    }
    // 使用了建造者模式
    @Override
    public int compareTo(Girl o) {
        return ComparisonChain.start()
                .compare(name,o.name)
                .compare(height,o.height)
                .compare(face,o.face)
                .result();
    }
}

```

###  Joiner类的学习使用

```

public class JoinTest {
    private static String sep = "|";
    private static List list = initTestingData();
    // HashMap 的一种新写法
    private static Map<String, String> map = new HashMap<String, String>() {
        private static final long serialVersionUID = 1L;

        {
            put("i love u", "u love me");
            put("i like u", "u like me");
            put("i hate u", "u hate me");
        }
    };

    private static List initTestingData() {
        List list = new ArrayList();
        for (int i = 0; i < 20; i++) {
            if (i % 5 == 0) {
                list.add(null);
            } else
                list.add("test" + i);
        }
        return list;
    }

    @Test
    public void testBuildStringWithJoin(){
        String str = Joiner.on(sep).skipNulls().join(list);
        System.out.println(str);
        String str2 = Joiner.on(sep).useForNull("hello").join(list);
        System.out.println(str2);

    }

    @Test
    public void testJoinerStringBuilder(){
        StringBuilder sb = new StringBuilder();
        Joiner joiner = Joiner.on(sep).skipNulls();
        joiner.appendTo(sb,"i love me","i like u ",null,"i hate u");
        System.out.println(sb.toString());

    }

    @Test
    public void testMapJoiner(){
        String str = Joiner.on(sep).withKeyValueSeparator("=").join(map);
        System.out.println(str);
    }

    @Test
    public void testJoiner(){
        String str1 = Joiner.on(";").skipNulls().join(Arrays.asList("a","b","c",null));
        assertEquals(str1,"a;b;c");
        String str2 = Joiner.on(",").join(Arrays.asList(1,5,7));
        assertEquals(str2,"1,5,7");
    }
}


输出
test1|test2|test3|test4|test6|test7|test8|test9|test11|test12|test13|test14|test16|test17|test18|test19
hello|test1|test2|test3|test4|hello|test6|test7|test8|test9|hello|test11|test12|test13|test14|hello|test16|test17|test18|test19
i love me|i like u |i hate u
i hate u=u hate me|i like u=u like me|i love u=u love me
```
skipNulls（）方法用于过滤集合中为null的元素，然后返回一个新的Joiner对象实例；
useForNull(String nullText)方法用于将集合中为null的元素替换成指定的字符串，并返回新的Joiner对象实例；
withKeyValueSeparator(String separator)方法，处理map时使用，接收map中key和value之间的分隔符；
join方法则用来接收需要处理的集合对象或object[]对象数组，返回处理后的字符串表示。

### Splitter的应用
```
@Test
    public void testSplitter() {
        // omitEmptyStrings方法用于忽略分割后产生的空值
        Iterable strings = Splitter.on(separator).omitEmptyStrings()
                .split(string);
        // [i hate u=u hate me , i like u=u like me , i love u=u love me]
        System.out.println(strings);
        // trimResults方法用于处理分割后每一项中的空白符
        Iterable strings2 = Splitter.on(separator)
                .trimResults().split(string);
        // [i hate u=u hate me, i like u=u like me, , , i love u=u love me]
        System.out.println(strings2);

        Iterable<String> string3 = Splitter.on(separator).omitEmptyStrings().trimResults().split(string);
        System.out.println(string3);
    }

输出为
[i hate u=u hate me , i like u=u like me , i love u=u love me]
[i hate u=u hate me, i like u=u like me, , , i love u=u love me]
[i hate u=u hate me, i like u=u like me, i love u=u love me]

@Test
    public void testMapSplitter() {
        Splitter.MapSplitter mapSplitter = Splitter.on(separator)
                .omitEmptyStrings().withKeyValueSeparator(separator2);
        Map<String, String> map = mapSplitter.split(string);
        Set keySet = map.keySet();
        // [i hate u, i like u, i love u]
        System.out.println(keySet);
    }
输出为
[i hate u, i like u, i love u]

```
Splitter是通过Splitter.on(分隔符).split(字符串)来处理字符串，与Joiner类似，通过静态on（）方法，我 们构建了一个Splitter对象，其中提供了两种常用的方法，分别是omitEmptyStrings（）和trimResults（），这两个方法的 调用都会返回一个新的Splitter对象实例。
omitEmptyStrings（）用于忽略字符串分割后产生的空值元素，trimResults（）用于去除字符串分割后子元素中的空白符。
与Joiner类似，Splitter也提供了一个内部类MapSplitter来处理字符串，返回map集合，调用方法为 withKeyValueSeparator(separator)，在静态on()方法之后调用，在分割后的子项中根据指定的separator再次分 割成key-value键值对，返回的结果为map集合。

### Guava Collection学习
FluentIterable是一个抽象类同时实现了 Iterable接口，内部提供了一个静态的from方法，用于接收一个Iterable接口的实现作为参数，返回一个包装了Iterable接口的 FluentIterable实例。FluentIterable可以链式调用toList、toSet、 toMap、 toSortedList以及toSortedSet等方法，转换为我们熟悉的集合类型。

FluentIterable.filter和FluentIterable.transform方法，顾名思义，分别用于集合的过滤和转换


```
public class Girl{
private List<Girl> girls;

    @Before
    public void setUp(){
        Girl g1 = new Girl(17, "nice");
        Girl g2 = new Girl(18, "beauty");
        Girl g3 = new Girl(19, "nice");
        Girl g4 = new Girl(18, "nice");
        girls = Lists.newArrayList(g1,g2,g3,g4);
    }
    @Test
    public void testFluentIterable(){
        /**
         * from方法：用于包装Iterable接口，返回FluentIterable实例
         * filter方法：用于过滤集合中元素，返回过滤后的集合
         */
        FluentIterable.from(girls).filter(new Predicate<Girl>() {
            @Override
            public boolean apply(Girl girl) {
                return "nice".equals(girl.getFace());
            }
        });
        /**
         * transform方法：用于根据指定Function转换集合元素，返回转换后的集合
         */
        FluentIterable<String> fluentIterable = FluentIterable.from(girls).transform(new Function<Girl, String>() {
            @Override
            public String apply(Girl girl) {
                return Joiner.on(",").join(girl.getAge(), girl.getFace());
            }
        });
    }
}

filter(Predicate<? super E> predicate)：
---> 接收一个Predicate作为参数，过滤那些能够满足predicate的元素，返回FluentIterable实例。

transform(Function<? super E, T> function)：
---> 接收一个Function作为参数，相应转换集合中的元素，返回FluentIterable实例。

```
#### Collections Lists
```
 @Test
    public void testLists() {
        /**
         * 一些构造List实例的方法很简单
         * 如：newArrayList(),newLinkedList()等
         * 这里不再赘述
         */
        String str = "i love u";//测试用
        String[] strs = {"i like u", "i miss u"};//测试用
        /**
         * asList：返回一个不可变的List
         * 其中包含指定的第一个元素和附加的元素数组组成
         * 修改这个数组将反映到返回的List上
         */
        List<String> list = Lists.asList(str, strs);
        System.out.println(list); //[i love u, i like u, i miss u]
        strs[1] = "i hate u";//对strs数组的修改会反映到List中
        System.out.println(list);//[i love u, i like u, i hate u]
        /**
         * transform：根据传进来的function对fromList进行相应的处理
         * 并将处理得到的结果存入到新的list对象中返回
         */
        List<String> newList = Lists.transform(list, new Function<String, String>() {
            @Override
            public String apply(String input) {
                //这里简单的对集合中的元素转换为大写
                return input.toUpperCase();
            }
        });
        System.out.println(newList);//[I LOVE U, I LIKE U, I HATE U]
         /**
         * partition：根据size传入的List进行切割，切割成符合要求的小的List
         * 并将这些小的List存入一个新的List对象中返回
         */
        List<List<String>> lists = Lists.partition(list, 2);
        System.out.println(lists);//[[i love u, i like u], [i hate u]]
        /**
         * charactersOf：将传进来的String或者CharSequence分割为单个的字符
         * 并存入到一个ImmutableList对象中返回
         * ImmutableList：一个高性能、不可变的、随机访问列表的实现
         */
        ImmutableList<Character> characters = Lists.charactersOf("realfighter");
        System.out.println(characters);//[r, e, a, l, f, i, g, h, t, e, r]
        /**
         * reverse：返回一个传入List内元素倒序后的List
         */
        List<String> reverse = Lists.reverse(list);
        System.out.println(reverse);//[i hate u, i like u, i love u]
    }
}
输出
[i love u, i like u, i miss u]
[i love u, i like u, i hate u]
[I LOVE U, I LIKE U, I HATE U]
[[i love u, i like u], [i hate u]]
[r, e, a, l, f, i, g, h, t, e, r]
[i hate u, i like u, i love u]
```
### CharMatcher
字符串匹配 && 字符处理
```
@Test
    public void testCharMatcher(){
        assertEquals(CharMatcher.DIGIT.retainFrom("some text 889983 and more"),"889983");
        assertEquals(CharMatcher.DIGIT.removeFrom("some text 889983 and more"),"some text  and more");
        assertEquals(CharMatcher.anyOf("abcxy").removeFrom("abcdefgxyz"),"defgz");
        String str1 = CharMatcher.inRange('a','f')
                .and(CharMatcher.isNot('c'))
                .and(CharMatcher.isNot('e'))
                .or(CharMatcher.is('z'))
                .replaceFrom("abyczef","*");
        assertEquals(str1,"**yc*e*");
    }
```
### Big Endian 和 Little Endian
```
public class CharUtil {
    /**
     * big endian是指低地址存放最高有效字节（MSB），而little endian则是低地址存放最低有效字节（LSB）
     * @param
     *          bytes
     * @return
     *          int
     */
    public static int byte2Int(byte[] bytes){
        int num = bytes[3] & 0xFF;
        num |= (bytes[2] << 8) & 0xFF00;
        num |= (bytes[1] << 16) & 0xFF0000;
        num |= (bytes[0] << 24) & 0xFF000000;
        return num;
    }

    public static byte[] int2ByteArray(int i){
        byte[] result = new byte[4];
        result[0] = (byte) ((i >> 24) & 0xFF);
        result[1] = (byte)((i >> 16 ) & 0xFF);
        result[2] = (byte)((i >> 8 ) & 0xFF);
        result[3] = (byte)(i & 0xFF);
        return result;
    }
}

```
测试代码
```
public class testNum {
    @Test
    public void testByte2Int(){

        byte[] bb = new byte[]{0,0,1,1};
        System.out.println(CharUtil.byte2Int(bb));
    }
    @Test
    public void testInt2ByteArray(){
        byte[] bt = CharUtil.int2ByteArray(258);
        for (int i = 0; i < bt.length; i++) {
            byte b = bt[i];
            System.out.println(b);
        }
    }
}
```
注意：OutputStream中直接写入一个int类型，会截取低8位，丢弃高24位，因此需要将基本类型先转换为字节流。Java采用的是BigEndian字节序，所有的网络协议都是采用BigEndian字节序来进行传输的，因此我们在进行数据的传输时，需要先将其转换成BigEndian字节序；同理，在数据接收时，也需要进行响应的转换

