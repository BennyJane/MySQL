1，取得每个部门最高薪水的人员名称？
mysql> select deptno,max(sal) as maxsal from emp group by deptno;
+--------+----------+
| deptno | max(sal) |
+--------+----------+
|     20 |  3000.00 |
|     30 |  2850.00 |
|     10 |  5000.00 |
+--------+----------+
(select deptno,max(sal) as maxsal from emp group by deptno) as t

select
	e.ename,t.*
from
	emp e
join
	(select deptno,max(sal) as maxsal from emp group by deptno) as t
on
	t.deptno=e.deptno and t.mxsal=e.sal;

+-------+--------+---------+
| ename | deptno | maxsal  |
+-------+--------+---------+
| BLAKE |     30 | 2850.00 |
| SCOTT |     20 | 3000.00 |
| KING  |     10 | 5000.00 |
| FORD  |     20 | 3000.00 |
+-------+--------+---------+
表链接+子查询
条件很重要。


2,哪些人的薪水在部门的平均薪水之上？
1）
select deptno,avg(sal) avgsal from emp group by deptno;
+--------+-------------+
| deptno | avgsal      |
+--------+-------------+
|     20 | 2175.000000 |
|     30 | 1566.666667 |
|     10 | 2916.666667 |
+--------+-------------+
2)
select
	e.ename,e.sal,t.*
from
	emp e
join
	(select deptno,avg(sal) as avgsal from emp group by deptno) as t
on
	t.deptno=e.deptno and e.sal>t.avgsal;

易错点：
select 必须有t.*的所有内容；最后表中的字段也是两者相加。
‘join’ 字母拼写。


3. 取的部门中（所有人的）平均的薪水等级？

1),
select e.ename,e.deptno,s.grade from emp e join salgrade s on e.sal between s.losal and s.hisal;
+--------+--------+-------+
| ename  | deptno | grade |
+--------+--------+-------+
| SIMITH |     20 |     1 |
| ALLEN  |     30 |     3 |
| WARD   |     30 |     2 |
| JONES  |     20 |     4 |
| MARTIN |     30 |     2 |
| BLAKE  |     30 |     4 |
| CLARK  |     10 |     4 |
| SCOTT  |     20 |     4 |
| KING   |     10 |     5 |
| TURNER |     30 |     3 |
| ADAMS  |     20 |     1 |
| JAMES  |     30 |     1 |
| FORD   |     20 |     4 |
| MILLER |     10 |     2 |
+--------+--------+-------+
2),
select 
	t.deptno,avg(grade) 
from 
	(select e.ename,e.deptno,s.grade from emp e join salgrade s on e.sal between s.losal and s.hisal) t 
group by 
	deptno;

+--------+------------+
| deptno | avg(grade) |
+--------+------------+
|     20 |     2.8000 |
|     30 |     2.5000 |
|     10 |     3.6667 |
+--------+------------+

3.1取得部门中所有人的平均薪水的等级
select deptno,avg(sal) avgsal from emp group by deptno;
+--------+-------------+
| deptno | avg(sal)    |
+--------+-------------+
|     20 | 2175.000000 |
|     30 | 1566.666667 |
|     10 | 2916.666667 |
+--------+-------------+
select
	t.*,s.grade
from 
	salgrade s
join
	(select deptno,avg(sal) avgsal from emp group by deptno) t
on
	t.avgsal between s.losal and hisal;	

+--------+-------------+-------+
| deptno | avgsal      | grade |
+--------+-------------+-------+
|     20 | 2175.000000 |     4 |
|     30 | 1566.666667 |     3 |
|     10 | 2916.666667 |     4 |
+--------+-------------+-------+

4,不准用组函数（Max），取得最高薪水（给出两种解决方案）

1），排序
select ename,sal from emp order by sal; 默认升序
select sal from emp order by sal desc;
+--------+---------+
| ename  | sal     |
+--------+---------+
| SIMITH |  800.00 |
| JAMES  |  950.00 |
| ADAMS  | 1100.00 |
| WARD   | 1250.00 |
| MARTIN | 1250.00 |
| MILLER | 1300.00 |
| TURNER | 1500.00 |
| ALLEN  | 1600.00 |
| CLARK  | 2450.00 |
| BLAKE  | 2850.00 |
| JONES  | 2975.00 |
| SCOTT  | 3000.00 |
| FORD   | 3000.00 |
| KING   | 5000.00 |
+--------+---------+
select sal from emp order by sal desc limit 1; 取第一个
+---------+
| sal     |
+---------+
| 5000.00 |
+---------+

2），利用Min（）函数 ------- 自连接（笛卡尔积）
select a.sal from emp a join emp b on a.sal<b.sal;

select
	sal
from
	emp
where
	sal
not in
	(select a.sal from emp a join emp b on a.sal<b.sal);

###
not in sth


5,取得平均薪水最高的部门的部门编号（至少给出两种解决方案）

第一种方案：
select deptno,avg(sal) avgsal from emp group by deptno
+--------+-------------+
| deptno | avgsal      |
+--------+-------------+
|     20 | 2175.000000 |
|     30 | 1566.666667 |
|     10 | 2916.666667 |
+--------+-------------+

select t.deptno,max(avgsal) from (select deptno,avg(sal) avgsal from emp group by deptno) t;

+--------+-------------+
| deptno | max(avgsal) |
+--------+-------------+
|     20 | 2916.666667 |
+--------+-------------+
考虑平均薪水可能相等。

###排序后取最大值。

第二种：

select
	deptno,avg(sal) as avgsal
from
	emp
group by
	deptno
having
	avg(sal)=(select avg(sal) avgsal from emp group by deptno order by avgsal desc limit 1); # 最后列表中只

能有sal，数值，不能带部门。



7，求平均薪水的等级最低的部门的部门的名称？

求部门的平均薪水
select deptno,avg(sal) from emp group by deptno;

+--------+-------------+
| deptno | avg(sal)    |
+--------+-------------+
|     20 | 2175.000000 |
|     30 | 1566.666667 |
|     10 | 2916.666667 |
+--------+-------------+

求个部门的平均薪水的薪水等级
select 
	s.grade,t.*
from 
	salgrade s
join 
	(select deptno,avg(sal) as avgsal from emp group by deptno) t
on
	t.avgsal between s.losal and hisal;

+-------+--------+-------------+
| grade | deptno | avgsal      |
+-------+--------+-------------+
|     4 |     20 | 2175.000000 |
|     3 |     30 | 1566.666667 |
|     4 |     10 | 2916.666667 |
+-------+--------+-------------+

select
	min(m.grade),m.deptno
from
	(select s.grade,t.* from salgrade s join (select deptno,avg(sal) as avgsal from emp group by deptno) t 

on t.avgsal between s.losal and hisal) m;

+--------------+--------+
| min(m.grade) | deptno |
+--------------+--------+
|            3 |     20 |
+--------------+--------+


select 
	d.dname,n.*
from
	dept d
join
	(select
	min(m.grade),m.deptno
from
	(select s.grade,t.* from salgrade s join (select deptno,avg(sal) as avgsal from emp group by deptno) t 

on t.avgsal between s.losal and hisal) m
) n
on
	d.deptno=n.deptno;

+-------------+--------------+--------+
| dname       | min(m.grade) | deptno |
+-------------+--------------+--------+
| RESEARCHING |            3 |     20 |
+-------------+--------------+--------+

求平均薪水的等级最高的部门的部门名称？----------经典

select
	d.dname,m.deptno,m.avgsal,m.grade
from
	dept d
join
	(select
	s.grade,t.*
from
	salgrade s
join
	(select deptno,avg(sal) avgsal from emp group by deptno) t 
on
	t.avgsal between s.losal and s.hisal	
	) m
on
	d.deptno=m.deptno
where
	m.grade=(select
	max(n.grade)
from
	(select
	s.grade,t.*
from
	salgrade s
join
	(select deptno,avg(sal) avgsal from emp group by deptno
) t
on
	t.avgsal between s.losal and hisal
) n);


mysql> select
    ->  n.deptno,max(n.grade),n.avgsal
    -> from
    ->  (select
    ->  s.grade,t.*
    -> from
    ->  salgrade s
    -> join
    ->  (select deptno,avg(sal) avgsal from emp group by deptno
    -> ) t
    -> on
    ->  t.avgsal between s.losal and hisal
    -> ) n;
+--------+--------------+-------------+
| deptno | max(n.grade) | avgsal      |
+--------+--------------+-------------+
|     20 |            4 | 2175.000000 |
+--------+--------------+-------------+
最大值为什么不是两个？ max()只能求一个值，当有两个相等的时候。


8,取得比普通员工（员工代码没有在mgr字段上出现的）的最高薪水还高的经理人姓名？


select 
	e.empno
from
	emp e
where
	e.empno 
not in
	(select 
		mgr
	from
		emp)
			
因为not in 不会自动忽略NULL，需要程序员手动排除NULL。

01 distintct
select 
	distinct mgr
from
	emp；
+------+
| mgr  |
+------+
| 7902 |
| 7698 |
| 7698 |
| 7839 |
| 7698 |
| 7839 |
| 7839 |
| 7566 |
| NULL |
| 7698 |
| 7788 |
| 7698 |
| 7566 |
| 7782 |
+------+
手动排空--### is not null
select 
	*
from
	emp e
where
	e.empno 
not in
	(select 
		mgr
	from
		emp
	where
		mgr is not null);
+-------+--------+----------+------+------------+---------+---------+--------+
| empno | ename  | job      | mgr  | hiredate   | sal     | comm    | deptno |
+-------+--------+----------+------+------------+---------+---------+--------+
|  7369 | SIMITH | CLERK    | 7902 | 1980-12-17 |  800.00 |    NULL |     20 |
|  7499 | ALLEN  | SALESMAN | 7698 | 1981-02-20 | 1600.00 |  300.00 |     30 |
|  7521 | WARD   | SALESMAN | 7698 | 1981-02-22 | 1250.00 |  500.00 |     30 |
|  7654 | MARTIN | SALESMAN | 7698 | 1981-09-28 | 1250.00 | 1400.00 |     30 |
|  7844 | TURNER | SALESMAN | 7698 | 1981-09-08 | 1500.00 |    NULL |     30 |
|  7876 | ADAMS  | CLERK    | 7788 | 1987-05-23 | 1100.00 |    NULL |     20 |
|  7900 | JAMES  | CLERK    | 7698 | 1981-12-03 |  950.00 |    NULL |     30 |
|  7934 | MILLER | CLERK    | 7782 | 1982-01-23 | 1300.00 |    NULL |     10 |
+-------+--------+----------+------+------------+---------+---------+--------+

select
	max(t.sal)
from
	(select 
	*
from
	emp e
where
	e.empno 
not in
	(select 
		mgr
	from
		emp
	where
		mgr is not null)
) t

+------------+
| max(t.sal) |
+------------+
|    1600.00 |
+------------+

#####简单方法：大于1600的就是经理人


 找到所有经理人的名称、薪水
select
	e.ename,e.sal
from
	emp e
join
	(select 
		distinct mgr
	from
		emp
	where
		mgr is not null) c
on
	e.empno=c.mgr
+-------+---------+
| ename | sal     |
+-------+---------+
| FORD  | 3000.00 |
| BLAKE | 2850.00 |
| KING  | 5000.00 |
| JONES | 2975.00 |
| SCOTT | 3000.00 |
| CLARK | 2450.00 |
+-------+---------+

select
	m.ename,m.sal
from
	(select
	e.ename,e.sal
from
	emp e
join
	(select 
		distinct mgr
	from
		emp
	where
		mgr is not null) c
on
	e.empno=c.mgr) m
where
	m.sal > (select
	max(t.sal)
from
	(select 
	*
from
	emp e
where
	e.empno 
not in
	(select 
		mgr
	from
		emp
	where
		mgr is not null)
) t);

+-------+---------+
| ename | sal     |
+-------+---------+
| JONES | 2975.00 |
| BLAKE | 2850.00 |
| CLARK | 2450.00 |
| SCOTT | 3000.00 |
| KING  | 5000.00 |
| FORD  | 3000.00 | 
+-------+---------+

错误
select ename,sal(case job when "MANAGER" then sal*1.1 when "SALESMAN" then sal*1.5 else sal end) as newsal from 

emp;



9，取得薪水最高的前五名员工
select ename,sal from emp order by sal desc limit 5;

+-------+---------+
| ename | sal     |
+-------+---------+
| KING  | 5000.00 |
| FORD  | 3000.00 |
| SCOTT | 3000.00 |
| JONES | 2975.00 |
| BLAKE | 2850.00 |
+-------+---------+


10,取得薪水最高的第六名到第十名员工？
select ename,sal from emp order by sal desc limit 6,5; （起始位置，长度）

+--------+---------+
| ename  | sal     |
+--------+---------+
| ALLEN  | 1600.00 |
| TURNER | 1500.00 |
| MILLER | 1300.00 |
| WARD   | 1250.00 |
| MARTIN | 1250.00 |
+--------+---------+

11，取得最后入职的5名员工；
select ename,hiredate from emp order by hiredate desc limit 5; （长度）
+--------+------------+
| ename  | hiredate   |
+--------+------------+
| ADAMS  | 1987-05-23 |
| SCOTT  | 1987-04-19 |
| MILLER | 1982-01-23 |
| JAMES  | 1981-12-03 |
| FORD   | 1981-12-03 |
+--------+------------+
12，取得每个薪水等级有多少员工？


select e.sal,s.grade from emp e join salgrade s where e.sal between s.losal and s.hisal; 
+---------+-------+
| sal     | grade |
+---------+-------+
|  800.00 |     1 |
| 1600.00 |     3 |
| 1250.00 |     2 |
| 2975.00 |     4 |
| 1250.00 |     2 |
| 2850.00 |     4 |
| 2450.00 |     4 |
| 3000.00 |     4 |
| 5000.00 |     5 |
| 1500.00 |     3 |
| 1100.00 |     1 |
|  950.00 |     1 |
| 3000.00 |     4 |
| 1300.00 |     2 |
+---------+-------+


按薪水等级分组：
select e.sal,s.grade from emp e join salgrade s where e.sal between s.losal and s.hisal group by s.grade;
+---------+-------+
| sal     | grade |
+---------+-------+
|  800.00 |     1 |
| 1600.00 |     3 |
| 1250.00 |     2 |
| 2975.00 |     4 |
| 5000.00 |     5 |
+---------+-------+

这张表有问题：按照grade分组，前面写e.sal 数据不全，只有五个数据；
按照grade分组，前面只能写 grade
select s.grade from emp e join salgrade s where e.sal between s.losal and s.hisal group by s.grade (having 

s.grade >=2);


select 
	t.grade,count(*) 
from
	(select e.sal,s.grade from emp e join salgrade s where e.sal between s.losal and s.hisal group by 

s.grade) t;错误原因：计算了t.grade的数量

正确解释
select s.grade,count(*)
from emp e 
join 
	salgrade s 
where 
	e.sal 
between s.losal and s.hisal 
group by 
	s.grade;
+-------+----------+
| grade | count(*) |
+-------+----------+
|     1 |        3 |
|     3 |        2 |
|     2 |        3 |
|     4 |        5 |
|     5 |        1 |
+-------+----------+
分组之后，计算。

13，面试题
有三张表s（学生表） c（课程表） sc（学生选课表）
s（sno，SNAMW） 学号，姓名
c（cno，CNAME，CTEACHER） 课号 课名 教师
sc （sno，cno，SCGRADE） 学号 课号 成绩

画表，
1对多
主键

“设计表”

s 学生表
sno（PK） sname
-------------------

c 课程表
cno（PK） cname cteachere

------------------- 

sc 学生选课表
sno（PK） cno（PK） scgrade
------------------
sno+cno 是复合主键
主键只有一个，同时sno cno都是外键，外键有两个


1） 找出没选过“黎明”老师的所有学生姓名（选过 or 没选过）

select
	SNAME
from
	s
where
	s.sno not in(
select
	sc.sno
from
	sc
where
	sc.cno=(select 
			c.cno
		from
			c
		where
			CNAME=‘黎明')
		);


select 
	s.SNAME
from 
	s 
join
	c
on
	s.sno not in c.sno;




2)列出2门以上（含两门）不及格学生姓名及平均成绩

select
	s.SNAME,t.avgsal
from
	s
join
	(select 
	sc.sno,avg(sc.SCGRADE) avgsal   错误，求的是每个同学不及格的课程的成绩平均值。
from
	sc
where
	sc.SCGRADE < 60
group by
	sc.sno;
having
	conut(*)>=2) t
on
	s.sno=t.sno；

修改
### 01
先求不及格课目大于等于2的学生名称

select 
	s.sname，s.sno
from
	sc
join
	s
on
	s.sno=sc.sno
where
	sc.SCGRADE < 60
group by
	s.name，s.sno
having
	conut(*)>=2);
###02
找出每一个学生的平均成绩
select sno,avg(scgrade) as avgscore from sc group by sno;

###03
将第一步 和 第二步 联合

select
	m.name,n,avgscore
from 
	(select 
	s.name，s.sno
from
	sc
join
	s
on
	s.sno=sc.sno
where
	sc.SCGRADE < 60
group by
	s.name，s.sno
having
	conut(*)>=2)) m
join
	(select sno,avg(scgrade) as avgscore from sc group by sno) n
on
	m.sno=n.sno;


###实验

select 
	sc.sno,avg(sc.SCGRADE) avgsal
from
	sc
where
	sc.SCGRADE < 60
group by
	sc.sno;
having
	conut(*)>=2;



select s.grade,count(*)
from emp e 
join 
	salgrade s 
where 
	e.sal 
between s.losal and s.hisal 
group by 
	s.grade
having
	count(*)>=2;

+-------+----------+
| grade | count(*) |
+-------+----------+
|     1 |        3 |
|     3 |        2 |
|     2 |        3 |
|     4 |        5 |
+-------+----------+
?select s.grade,count(*),avg(e.sal)
from emp e 
join 
	salgrade s 
where 
	e.sal 
between s.losal and s.hisal 
group by 
	s.grade
having
	count(*)>=2;
+-------+----------+-------------+
| grade | count(*) | avg(e.sal)  |
+-------+----------+-------------+
|     1 |        3 |  950.000000 |
|     3 |        2 | 1550.000000 |
|     2 |        3 | 1266.666667 |
|     4 |        5 | 2855.000000 |
+-------+----------+-------------+


3),既学过1号课程又学过2号课程所有学生的姓名
##01
select 
	sno
from
	sc
where
	cno=1;

select
	sno
from 
	sc
where
	cno=2;

##02
select
	sno
from
	(select 
	sno
from
	sc
where
	cno=1) m
join
	(select
	sno
from 
	sc
where
	cno=2) n
on 
	m.cno not in n.cno; 

##03
select
	CNAME
from 
	s
join
	(select 
	sno
from
	sc
where
	cno=1) m
join
	(select
	sno
from 
	sc
where
	cno=2) n
on 
	m.cno not in n.cno) w
no
	s.cno=w.cno;



教程方法

select
	s.sname
from
	sc
join
	s
on	
	sc.sno=s.sno
where
	sc.cno=1 and sc.sno in (select sno from sc where cno=2);


T60
14,列出所有员工 领导的姓名
select
	a.ename empname, b.ename leadername
from 
	emp a
join 
	emp b
on 
	a.mgr = b.empno;
左链接，左表中的数据，即使没有对应数据，也要保留。
+---------+------------+
| empname | leadername |
+---------+------------+
| SIMITH  | FORD       |
| ALLEN   | BLAKE      |
| WARD    | BLAKE      |
| JONES   | KING       |
| MARTIN  | BLAKE      |
| BLAKE   | KING       |
| CLARK   | KING       |
| SCOTT   | JONES      |
| KING    | NULL       |
| TURNER  | BLAKE      |
| ADAMS   | SCOTT      |
| JAMES   | BLAKE      |
| FORD    | JONES      |
| MILLER  | CLARK      |
+---------+------------+
select
	a.ename empname, b.ename leadername
from 
	emp a
join 
	emp b
on 
	a.mgr = b.empno;

+---------+------------+
| empname | leadername |
+---------+------------+
| SIMITH  | FORD       |
| ALLEN   | BLAKE      |
| WARD    | BLAKE      |
| JONES   | KING       |
| MARTIN  | BLAKE      |
| BLAKE   | KING       |
| CLARK   | KING       |
| SCOTT   | JONES      |
| TURNER  | BLAKE      |
| ADAMS   | SCOTT      |
| JAMES   | BLAKE      |
| FORD    | JONES      |
| MILLER  | CLARK      |
+---------+------------+

15，列出受雇日期早于其直接上级的所有员工的编号、姓名、部门名称
注释：
1，日期的比较
2，先得到 编号 姓名 部门编号（符合条件）
3，再求部门名称


select
	a.ename empname,a.hiredate,b.ename leadername,b.hiredate
from 
	emp a
join 
	emp b
on 
	a.mgr = b.empno
having
	a.hiredate < b.hiredate;
+---------+------------+------------+------------+
| empname | hiredate   | leadername | hiredate   |
+---------+------------+------------+------------+
| SIMITH  | 1980-12-17 | FORD       | 1981-12-03 |
| ALLEN   | 1981-02-20 | BLAKE      | 1981-05-01 |
| WARD    | 1981-02-22 | BLAKE      | 1981-05-01 |
| JONES   | 1981-04-02 | KING       | 1981-11-17 |
| BLAKE   | 1981-05-01 | KING       | 1981-11-17 |
| CLARK   | 1981-06-09 | KING       | 1981-11-17 |
+---------+------------+------------+------------+

select
	a.empno,a.ename empname,a.deptno,a.hiredate,b.hiredate date
from 
	emp a
join 
	emp b
on 
	a.mgr = b.empno
having
	a.hiredate < b.hiredate;

或者 where a.hiredate < b.hiredate
+-------+---------+--------+------------+------------+
| empno | empname | deptno | hiredate   | date       |
+-------+---------+--------+------------+------------+
|  7369 | SIMITH  |     20 | 1980-12-17 | 1981-12-03 |
|  7499 | ALLEN   |     30 | 1981-02-20 | 1981-05-01 |
|  7521 | WARD    |     30 | 1981-02-22 | 1981-05-01 |
|  7566 | JONES   |     20 | 1981-04-02 | 1981-11-17 |
|  7698 | BLAKE   |     30 | 1981-05-01 | 1981-11-17 |
|  7782 | CLARK   |     10 | 1981-06-09 | 1981-11-17 |
+-------+---------+--------+------------+------------+

求部门名称

select
	t.empno,t.empname,d.dname
from
	(select
	a.empno,a.ename empname,a.deptno,a.hiredate,b.hiredate date
from 
	emp a
join 
	emp b
on 
	a.mgr = b.empno
having
	a.hiredate < b.hiredate
) t
join
	dept d
on
	t.deptno=d.deptno;
+-------+---------+-------------+
| empno | empname | dname       |
+-------+---------+-------------+
|  7782 | CLARK   | ACCOUNTING  |
|  7369 | SIMITH  | RESEARCHING |
|  7566 | JONES   | RESEARCHING |
|  7499 | ALLEN   | SALES       |
|  7521 | WARD    | SALES       |
|  7698 | BLAKE   | SALES       |
+-------+---------+-------------+


教程案例：连续的表链接

select
	a.empno ‘员工编号’,a.ename  '员工姓名',d.dname ‘部门名称’
from
	emp a
join
	emp b
on
	a.mgr=b.empno
join
	dept d
on
	a.deptno=d.deptno
where
	a.hiredate<b.hiredate;

+--------------------+--------------+--------------------+
| ‘员工编号’       | 员工姓名     | ‘部门名称’         |
+--------------------+--------------+--------------------+
|               7369 | SIMITH       | RESEARCHING        |
|               7499 | ALLEN        | SALES              |
|               7521 | WARD         | SALES              |
|               7566 | JONES        | RESEARCHING        |
|               7698 | BLAKE        | SALES              |
|               7782 | CLARK        | ACCOUNTING         |
+--------------------+--------------+--------------------+

16,l列出部门名称和这些部门的员工信息，同时列出那些没有员工的部门

select
	e.*,d.deptno,d.dname
from
	emp e
right join
	dept d
on
	e.deptno=d.deptno;	

+-------+--------+-----------+------+------------+---------+---------+--------+--------+-------------+
| empno | ename  | job       | mgr  | hiredate   | sal     | comm    | deptno | deptno | dname       |
+-------+--------+-----------+------+------------+---------+---------+--------+--------+-------------+
|  7369 | SIMITH | CLERK     | 7902 | 1980-12-17 |  800.00 |    NULL |     20 |     20 | RESEARCHING |
|  7499 | ALLEN  | SALESMAN  | 7698 | 1981-02-20 | 1600.00 |  300.00 |     30 |     30 | SALES       |
|  7521 | WARD   | SALESMAN  | 7698 | 1981-02-22 | 1250.00 |  500.00 |     30 |     30 | SALES       |
|  7566 | JONES  | MANAGER   | 7839 | 1981-04-02 | 2975.00 |    NULL |     20 |     20 | RESEARCHING |
|  7654 | MARTIN | SALESMAN  | 7698 | 1981-09-28 | 1250.00 | 1400.00 |     30 |     30 | SALES       |
|  7698 | BLAKE  | MANAGER   | 7839 | 1981-05-01 | 2850.00 |    NULL |     30 |     30 | SALES       |
|  7782 | CLARK  | MANAGER   | 7839 | 1981-06-09 | 2450.00 |    NULL |     10 |     10 | ACCOUNTING  |
|  7788 | SCOTT  | ANALYST   | 7566 | 1987-04-19 | 3000.00 |    NULL |     20 |     20 | RESEARCHING |
|  7839 | KING   | PRESIDENT | NULL | 1981-11-17 | 5000.00 |    NULL |     10 |     10 | ACCOUNTING  |
|  7844 | TURNER | SALESMAN  | 7698 | 1981-09-08 | 1500.00 |    NULL |     30 |     30 | SALES       |
|  7876 | ADAMS  | CLERK     | 7788 | 1987-05-23 | 1100.00 |    NULL |     20 |     20 | RESEARCHING |
|  7900 | JAMES  | CLERK     | 7698 | 1981-12-03 |  950.00 |    NULL |     30 |     30 | SALES       |
|  7902 | FORD   | ANALYST   | 7566 | 1981-12-03 | 3000.00 |    NULL |     20 |     20 | RESEARCHING |
|  7934 | MILLER | CLERK     | 7782 | 1982-01-23 | 1300.00 |    NULL |     10 |     10 | ACCOUNTING  |
|  NULL | NULL   | NULL      | NULL | NULL       |    NULL |    NULL |   NULL |     40 | OPERATIONS  |
+-------+--------+-----------+------+------------+---------+---------+--------+--------+-------------+

17列出至少有5个员工的所有部门[部门详细信息]

select
	e.deptno,count(e.ename)
from
	emp e
group by
	e.deptno
having
	count(e.ename)>= 5;

注意： count(e.ename)>=5

+--------+----------------+
| deptno | count(e.ename) |
+--------+----------------+
|     20 |              5 |
|     30 |              6 |
+--------+----------------+
select
	e.deptno,count(*)
from
	emp e
group by
	e.deptno
having
	count(*);

+--------+----------+
| deptno | count(*) |
+--------+----------+
|     20 |        5 |
|     30 |        6 |
|     10 |        3 |
+--------+----------+
