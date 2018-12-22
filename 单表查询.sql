#去除重复数据(仅仅去除最后呈现结果中重复数据；数据库不更改。)
select disticnt job from emp;
#select ename,disticnt jon from em; （disticnt 之前不能出现字段，只能放在字段最前面）
select disticnt deptno,job from emp; #去除两个字段均相同的数据。
select count(disticnt job) from emp;

### 分组查询：

# group by 通过哪个或者哪些字段进行分组
#order by 
#求每个工作岗位的最高薪水
select max(sal) from emp group by job;
#先按照job分组，然后对每一组使用max（sal）求最大值
select job,max(sal) from emp group by job;
#正确（注意执行顺序），分组后，求job、max（sal）数据量相同，存在对应关系。
#若DQL语句当中有group by子语句，select 关键词 后只能跟参加分组的字段及分组的函数
select ename,job,max(sal) from emp group by job;
#错误（❌）：在oracle 中不可以执行；在mysql可以执行，mysql语句松散。
# 计算不同部分的不同工作岗位的最高薪水
select deptno,job,max(sal) from emp group by deptno,job; # order by name,name;
#deptno,job 联合起来分组；

select job,max(sal) from emp where job<>'MANAGER' group by job;
#找出每个工作岗位的最高薪水，不包括MANAGER在内。
select job,avg(sal) from emp where avg(sal) group by job; 
#错误（❌）：where 后面不能直接跟分组函数，分组函数必须在分组之后执行。此时未分组；where先执行。

having
		having where 功能都是为了完成数据的过滤
		having where后面都是添加条件
		where 在 group by 之前完成过滤
		having 在 group by 之后完成过滤
		优先使用 where，效率更高；在分组之前，优先过滤掉无用数据，无法过滤掉可以在分组之后用 having 过滤
select job,avg(sal) from emp group by job having avg(sal)>1500;

#一个完整的DQL语句的总结
	第一：以下的关键词顺序不能变，严格遵守
	第二：执行顺序：
	1，from 从某张表中检索数据
	2，where 经过某条件进行过滤
	3，group by 然后分组
	4，having 分组之后不满意再过滤
	5，select 查询出来
	6，order by 排序输出
select ...
from ...
where ...
group by ...
having ...
order by...; 



