

18,列出薪金比“SIMITH”多的所有员工的信息

select
	e.*
from
	emp e
where
	e.sal>(select b.sal from emp b where b.ename= 'SIMITH' );

+-------+--------+-----------+------+------------+---------+---------+--------+
| empno | ename  | job       | mgr  | hiredate   | sal     | comm    | deptno |
+-------+--------+-----------+------+------------+---------+---------+--------+
|  7499 | ALLEN  | SALESMAN  | 7698 | 1981-02-20 | 1600.00 |  300.00 |     30 |
|  7521 | WARD   | SALESMAN  | 7698 | 1981-02-22 | 1250.00 |  500.00 |     30 |
|  7566 | JONES  | MANAGER   | 7839 | 1981-04-02 | 2975.00 |    NULL |     20 |
|  7654 | MARTIN | SALESMAN  | 7698 | 1981-09-28 | 1250.00 | 1400.00 |     30 |
|  7698 | BLAKE  | MANAGER   | 7839 | 1981-05-01 | 2850.00 |    NULL |     30 |
|  7782 | CLARK  | MANAGER   | 7839 | 1981-06-09 | 2450.00 |    NULL |     10 |
|  7788 | SCOTT  | ANALYST   | 7566 | 1987-04-19 | 3000.00 |    NULL |     20 |
|  7839 | KING   | PRESIDENT | NULL | 1981-11-17 | 5000.00 |    NULL |     10 |
|  7844 | TURNER | SALESMAN  | 7698 | 1981-09-08 | 1500.00 |    NULL |     30 |
|  7876 | ADAMS  | CLERK     | 7788 | 1987-05-23 | 1100.00 |    NULL |     20 |
|  7900 | JAMES  | CLERK     | 7698 | 1981-12-03 |  950.00 |    NULL |     30 |
|  7902 | FORD   | ANALYST   | 7566 | 1981-12-03 | 3000.00 |    NULL |     20 |
|  7934 | MILLER | CLERK     | 7782 | 1982-01-23 | 1300.00 |    NULL |     10 |
+-------+--------+-----------+------+------------+---------+---------+--------+

select b.sal from emp b where b.ename= 'SIMITH';

+--------+
| sal    |
+--------+
| 800.00 |
+--------+

优化：
select * from emp where sal >(select sal from emp where ename='SIMITH');


19,列出所有‘CLERk’的姓名及部门名称、部门的人数

部门人数指，该部门的所有人数


select
	e.ename,d.dname,d.deptno
from
	emp e
join
	dept d
on
	e.deptno=d.deptno
where 
	e.job='CLERK';

+--------+-------------+--------+
| ename  | dname       | deptno |
+--------+-------------+--------+
| SIMITH | RESEARCHING |     20 |
| ADAMS  | RESEARCHING |     20 |
| JAMES  | SALES       |     30 |
| MILLER | ACCOUNTING  |     10 |
+--------+-------------+--------+

错误？？
select
	t.*,count(e.ename)
from
	emp e
join
	(select
	e.ename,d.dname,d.deptno
from
	emp e
join
	dept d
on
	e.deptno=d.deptno
where 
	e.job='CLERK') t
on
	e.ename=t.ename
group by
	e.deptno;
	

select
	e.ename,d.dname,totalEmp
from 	
	dept d
join
	emp e
on
	e.deptno=d.deptno
join
	(select n.deptno,count(*) totalEmp from emp n group by n.deptno) t
on
	d.deptno=t.deptno
where
	e.job='CLERK';
+--------+-------------+----------+
| ename  | dname       | totalEmp |
+--------+-------------+----------+
| SIMITH | RESEARCHING |        5 |
| ADAMS  | RESEARCHING |        5 |
| JAMES  | SALES       |        6 |
| MILLER | ACCOUNTING  |        3 |
+--------+-------------+----------+

20，列出最低薪金大于1500的各种工作以及从事此工作的全部雇员人数

select
	e.job,count(e.ename)
from
	emp e
group  by
	e.job
having
	min(e.sal)>1500;

+-----------+----------------+
| job       | count(e.ename) |
+-----------+----------------+
| MANAGER   |              3 |
| ANALYST   |              2 |
| PRESIDENT |              1 |
+-----------+----------------+




21，列出在部门‘SALES’工作的员工的姓名，假定不知道销售部的部门编号

select
	e.ename
from
	emp e
join
	dept d
on
	e.deptno=d.deptno
where
	d.dname='SALES';
+--------+
| ename  |
+--------+
| ALLEN  |
| WARD   |
| MARTIN |
| BLAKE  |
| TURNER |
| JAMES  |
+--------+	

22,列出薪金高于公司平均薪金的所有员工，所在部门，上级领导 员工的工资等级

select
	e.ename,d.dname,m.ename leadername,s.grade
from
	emp e
join
	dept d
on
	e.deptno=d.deptno
join
	emp m
on
	e.mgr=m.empno
join
	salgrade s
on
	e.sal between s.losal and s.hisal
where
	e.sal>(select avg(sal) from emp);

没有5000,king 没有上级领导
e.sal between s.losal and s.hisal
s.losal<e.sal<=s.hisal
+-------+-------------+------------+-------+
| ename | dname       | leadername | grade |
+-------+-------------+------------+-------+
| JONES | RESEARCHING | KING       |     4 |
| BLAKE | SALES       | KING       |     4 |
| CLARK | ACCOUNTING  | KING       |     4 |
| SCOTT | RESEARCHING | JONES      |     4 |
| FORD  | RESEARCHING | JONES      |     4 |
+-------+-------------+------------+-------+

select
	e.ename,d.dname,m.ename leadername,s.grade
from
	emp e
join
	dept d
on
	e.deptno=d.deptno
left join
	emp m
on
	e.mgr=m.empno
join
	salgrade s
on
	e.sal between s.losal and s.hisal
where
	e.sal>(select avg(sal) from emp);

+-------+-------------+------------+-------+
| ename | dname       | leadername | grade |
+-------+-------------+------------+-------+
| JONES | RESEARCHING | KING       |     4 |
| BLAKE | SALES       | KING       |     4 |
| CLARK | ACCOUNTING  | KING       |     4 |
| SCOTT | RESEARCHING | JONES      |     4 |
| FORD  | RESEARCHING | JONES      |     4 |
| KING  | ACCOUNTING  | NULL       |     5 |
+-------+-------------+------------+-------+


mysql> select avg(sal) from emp;
+-------------+
| avg(sal)    |
+-------------+
| 2073.214286 |
+-------------+

+--------+-------------+------------+-------+
| ename  | dname       | leadername | grade |
+--------+-------------+------------+-------+
| SIMITH | RESEARCHING | FORD       |     1 |
| ALLEN  | SALES       | BLAKE      |     3 |
| WARD   | SALES       | BLAKE      |     2 |
| JONES  | RESEARCHING | KING       |     4 |
| MARTIN | SALES       | BLAKE      |     2 |
| BLAKE  | SALES       | KING       |     4 |
| CLARK  | ACCOUNTING  | KING       |     4 |
| SCOTT  | RESEARCHING | JONES      |     4 |
| TURNER | SALES       | BLAKE      |     3 |
| ADAMS  | RESEARCHING | SCOTT      |     1 |
| JAMES  | SALES       | BLAKE      |     1 |
| FORD   | RESEARCHING | JONES      |     4 |
| MILLER | ACCOUNTING  | CLARK      |     2 |
+--------+-------------+------------+-------+


23，列出与“SCOTT”从事相同工作的所有员工及部门名称

select
	e.ename,d.dname
from 
	emp e
join
	dept d
on
	e.deptno=d.deptno
where 
	e.job=(select job from emp where ename='SCOTT');

+-------+-------------+
| ename | dname       |
+-------+-------------+
| SCOTT | RESEARCHING |
| FORD  | RESEARCHING |
+-------+-------------+

24,列出薪金等于部门30中员工的薪金和其他员工的姓名与薪金
select
	e.ename,e.sal
from
	emp e
where
	e.sal in (select distinct sal from emp where deptno=30) and e.deptno <> 30 ;

无结果

mysql> select sal from emp where deptno=30;
+---------+
| sal     |
+---------+
| 1600.00 |
| 1250.00 |
| 1250.00 |
| 2850.00 |
| 1500.00 |
|  950.00 |
+---------+


25，列出薪金高于在部门30工作的所有员工的薪金的员工姓名和薪金，部门名称

select
	e.ename,e.sal,d.dname,d.deptno
from
	emp e
join
	dept d
on
	e.deptno=d.deptno
where
	e.sal >(select max(sal) from emp where deptno=30) and e.deptno <>30;

+-------+---------+-------------+
| ename | sal     | dname       |
+-------+---------+-------------+
| JONES | 2975.00 | RESEARCHING |
| SCOTT | 3000.00 | RESEARCHING |
| KING  | 5000.00 | ACCOUNTING  |
| FORD  | 3000.00 | RESEARCHING |
+-------+---------+-------------+

+-------+---------+-------------+--------+
| ename | sal     | dname       | deptno |
+-------+---------+-------------+--------+
| JONES | 2975.00 | RESEARCHING |     20 |
| SCOTT | 3000.00 | RESEARCHING |     20 |
| KING  | 5000.00 | ACCOUNTING  |     10 |
| FORD  | 3000.00 | RESEARCHING |     20 |
+-------+---------+-------------+--------+

26,列出在每个部门工作的员工的数量，平均工资 平均服务期限 -----P71
平均服务期限，工作年限
to_days()


select
	b.deptno,avg(now()-b.hiredate)
from
	emp b
group by
	b.deptno;
+--------+-----------------------+
| deptno | avg(now()-b.hiredate) |
+--------+-----------------------+
|     20 |   20181210339788.2000 |
|     30 |   20181210361877.3333 |
|     10 |   20181210358591.3333 |
+--------+-----------------------+


select
	avg(e.sal),count(e.ename) totalemp,d.deptno
from
	emp e
right join
	dept d
on
	e.deptno=d.deptno
group by
	e.deptno;

+-------------+----------------+
| avg(e.sal)  | count(e.ename) |
+-------------+----------------+
| 2175.000000 |              5 |
| 1566.666667 |              6 |
| 2916.666667 |              3 |
+-------------+----------------+

+-------------+----------------+--------+
| avg(e.sal)  | count(e.ename) | deptno |
+-------------+----------------+--------+
| 2175.000000 |              5 |     20 |
| 1566.666667 |              6 |     30 |
| 2916.666667 |              3 |     10 |
|        NULL |              0 |     40 |
+-------------+----------------+--------+
修正：将avg中的null 改为数字
空值处理函数：
ifnull(acg(e.sal),0) avgsal

正确做法：
select
	count(e.ename) totalemp,
	d.deptno,
	ifnull(avg(e.sal),0) as avgsal,
	ifnull(avg( (to_days(now())-to_days(e.hiredate))/365),0) as avgtime
from
	emp e
right join
	dept d
on
	e.deptno=d.deptno
group by
	e.deptno;

+----------+--------+-------------+-------------+
| totalemp | deptno | avgsal      | avgtime     |
+----------+--------+-------------+-------------+
|        5 |     20 | 2175.000000 | 35.25534000 |
|        6 |     30 | 1566.666667 | 37.52693333 |
|        3 |     10 | 2916.666667 | 37.22833333 |
|        0 |     40 |    0.000000 |  0.00000000 |
+----------+--------+-------------+-------------+
select
	deptno,(to_days(now())-to_days(hiredate))/365
from
	emp e
group by
	e.deptno;

+--------+---------------------------------+
| deptno | (to_days(now())-b.hiredate)/365 |
+--------+---------------------------------+
|     20 |                     -52229.5726 |
|     30 |                     -52254.2384 |
|     30 |                     -52254.2438 |
|     20 |                     -52254.7370 |
|     30 |                     -52256.1781 |
|     30 |                     -52255.0082 |
|     10 |                     -52255.3041 |
|     20 |                     -52419.1671 |
|     10 |                     -52256.6959 |
|     30 |                     -52256.1233 |
|     20 |                     -52419.4521 |
|     30 |                     -52256.9315 |
|     20 |                     -52256.9315 |
|     10 |                     -52281.3699 |
+--------+---------------------------------+

select
	ifnull(avg( (to_days(now())-to_days(e.hiredate))/365),0) as avgtime
from
	emp e
group by
	e.deptno;

+-------------+
| avgtime     |
+-------------+
| 35.25534000 |
| 37.52693333 |
| 37.22833333 |
+-------------+





27，列出所有员工的姓名 部门名称 工资

select
	e.ename,e.sal,d.dname
from
	emp e
join
	dept d
on
	e.deptno=d.deptno;
+--------+---------+-------------+
| ename  | sal     | dname       |
+--------+---------+-------------+
| SIMITH |  800.00 | RESEARCHING |
| ALLEN  | 1600.00 | SALES       |
| WARD   | 1250.00 | SALES       |
| JONES  | 2975.00 | RESEARCHING |
| MARTIN | 1250.00 | SALES       |
| BLAKE  | 2850.00 | SALES       |
| CLARK  | 2450.00 | ACCOUNTING  |
| SCOTT  | 3000.00 | RESEARCHING |
| KING   | 5000.00 | ACCOUNTING  |
| TURNER | 1500.00 | SALES       |
| ADAMS  | 1100.00 | RESEARCHING |
| JAMES  |  950.00 | SALES       |
| FORD   | 3000.00 | RESEARCHING |
| MILLER | 1300.00 | ACCOUNTING  |
+--------+---------+-------------+


28，列出所有部门的消息信息和人数

select
	d.*,count(e.ename)
from
	emp e
right join
	dept d
on
	e.deptno=d.deptno
group by
	d.deptno;	

+--------+-------------+----------+----------------+
| deptno | dname       | loc      | count(e.ename) |
+--------+-------------+----------+----------------+
|     20 | RESEARCHING | DALLAS   |              5 |
|     30 | SALES       | CHICAGO  |              6 |
|     10 | ACCOUNTING  | NEW YORK |              3 |
|     40 | OPERATIONS  | BOSTON   |              0 |
+--------+-------------+----------+----------------+


29,列出各种工作的最低工资及从事此工作的雇员名称

select
	min(e.sal),e.job
from
	emp e
group by
	e.job;
+------------+-----------+
| min(e.sal) | job       |
+------------+-----------+
|     800.00 | CLERK     |
|    1250.00 | SALESMAN  |
|    2450.00 | MANAGER   |
|    3000.00 | ANALYST   |
|    5000.00 | PRESIDENT |
+------------+-----------+

select
	b.ename,t.*
from
	emp b
join
	(select
	min(e.sal) minsal,e.job
from
	emp e
group by
	e.job) t
on
	b.job=t.job and b.sal=t.minsal;

+--------+---------+-----------+
| ename  | minsal  | job       |
+--------+---------+-----------+
| SIMITH |  800.00 | CLERK     |
| WARD   | 1250.00 | SALESMAN  |
| MARTIN | 1250.00 | SALESMAN  |
| CLARK  | 2450.00 | MANAGER   |
| SCOTT  | 3000.00 | ANALYST   |
| KING   | 5000.00 | PRESIDENT |
| FORD   | 3000.00 | ANALYST   |
+--------+---------+-----------+



30，列出各个部门的MANAGER 的最低薪水

select
	min(e.sal),e.deptno
from
	emp e
join
	emp b
on
	b.mgr=e.empno
group by
	e.deptno;

+------------+--------+
| min(e.sal) | deptno |
+------------+--------+
|    2975.00 |     20 |
|    2850.00 |     30 |
|    2450.00 |     10 |
+------------+--------+

31,列出所有员工的年工资，按年薪从低到高排序；

select
	ename,(sal+ifnull(comm,0))*12 yearsal
from
	emp
order by
	yearsal asc;

+--------+----------+
| ename  | yearsal  |
+--------+----------+
| SIMITH |  9600.00 |
| JAMES  | 11400.00 |
| ADAMS  | 13200.00 |
| MILLER | 15600.00 |
| TURNER | 18000.00 |
| WARD   | 21000.00 |
| ALLEN  | 22800.00 |
| CLARK  | 29400.00 |
| MARTIN | 31800.00 |
| BLAKE  | 34200.00 |
| JONES  | 35700.00 |
| SCOTT  | 36000.00 |
| FORD   | 36000.00 |
| KING   | 60000.00 |
+--------+----------+

32,求出员工领导的薪水超过3000的员工名称与领导名称
select
	b.sal,e.ename,b.ename leadername
from
	emp e
join
	emp b
on
	e.mgr=b.empno
where
	b.sal>3000;

+---------+-------+------------+
| sal     | ename | leadername |
+---------+-------+------------+
| 5000.00 | JONES | KING       |
| 5000.00 | BLAKE | KING       |
| 5000.00 | CLARK | KING       |
+---------+-------+------------+

33，求出部门名称中，带‘S’字符的部门员工的工资合计、部门人数

select
	d.dname,sum(ifnull(e.sal,0)) sunsal,count(e.ename) totalemp
from
	emp e
right join
	dept d
on
	e.deptno=d.deptno
where
	d.dname like '%S%'
group by
	d.dname;
+-------------+------------+
| dname       | sum(e.sal) |
+-------------+------------+
| RESEARCHING |   10875.00 |
| SALES       |    9400.00 |
| OPERATIONS  |       NULL |
+-------------+------------+

ifnull
+-------------+----------------------+
| dname       | sum(ifnull(e.sal,0)) |
+-------------+----------------------+
| RESEARCHING |             10875.00 |
| SALES       |              9400.00 |
| OPERATIONS  |                 0.00 |
+-------------+----------------------+
count(*)
+-------------+----------+----------+
| dname       | sunsal   | totalemp |
+-------------+----------+----------+
| RESEARCHING | 10875.00 |        5 |
| SALES       |  9400.00 |        6 |
| OPERATIONS  |     0.00 |        0 |
+-------------+----------+----------+


另一种方法：
select
	d.deptno,sum(e.sal) as sumsal,count(e.ename) as totalemp,d.dname
from
	emp e
right join
	dept d
on
	e.deptno=d.deptno
group by
	e.deptno
having
	d.dname like '%S%';
 
为什么不能用 having clause,中出现 的d.name，必须在select中出现。

+--------+----------+----------+-------------+
| deptno | sumsal   | totalemp | dname       |
+--------+----------+----------+-------------+
|     20 | 10875.00 |        5 | RESEARCHING |
|     30 |  9400.00 |        6 | SALES       |
|     40 |     NULL |        0 | OPERATIONS  |
+--------+----------+----------+-------------+

select
	count(ename) totalemp
from
	emp
group by
	deptno;
+--------------+
| count(ename) |
+--------------+
|            5 |
|            6 |
|            3 |
+--------------+


34,给任职日期超过30年的员工加薪30%

select
	e.ename,e.hiredate,e.sal,(sal*1.3) newsal
from
	emp e
where
	((to_days(now())-to_days(e.hiredate))/365)>30;

+--------+------------+---------+---------+
| ename  | hiredate   | sal     | newsal  |
+--------+------------+---------+---------+
| SIMITH | 1980-12-17 |  800.00 | 1040.00 |
| ALLEN  | 1981-02-20 | 1600.00 | 2080.00 |
| WARD   | 1981-02-22 | 1250.00 | 1625.00 |
| JONES  | 1981-04-02 | 2975.00 | 3867.50 |
| MARTIN | 1981-09-28 | 1250.00 | 1625.00 |
| BLAKE  | 1981-05-01 | 2850.00 | 3705.00 |
| CLARK  | 1981-06-09 | 2450.00 | 3185.00 |
| SCOTT  | 1987-04-19 | 3000.00 | 3900.00 |
| KING   | 1981-11-17 | 5000.00 | 6500.00 |
| TURNER | 1981-09-08 | 1500.00 | 1950.00 |
| ADAMS  | 1987-05-23 | 1100.00 | 1430.00 |
| JAMES  | 1981-12-03 |  950.00 | 1235.00 |
| FORD   | 1981-12-03 | 3000.00 | 3900.00 |
| MILLER | 1982-01-23 | 1300.00 | 1690.00 |
+--------+------------+---------+---------+


更新列表
create table emp_bak as select * from emp
update emp_bak set sal=sal*1.1 where ((to_days(now())-to_days(hiredate))/365)>30;

