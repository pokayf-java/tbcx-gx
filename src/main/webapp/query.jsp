<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>人民币冠字号码查询信息管理系统V3.0</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<style>
.freezeLayer {
	width: 100%;
	height: 100%;
	position: fixed;
	top: 0px;
	left: 0px;
	background: #fff;
	filter: Alpha(Opacity = 70);
	-moz-opacity: 0.7;
	opacity: 0.7;
	z-index: 20;
}

.loading {
	text-align: center;
	font-size: 18px;
	font-family: '黑体';
	color: green;
	covertical-align: middle;
	padding-top: 260px;
	padding-bottom: 260px;
}
</style>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/style/blue/button.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/style/blue/query.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/style/blue/popup.css">
<script src="${pageContext.request.contextPath}/js/jquery-1.7.2.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-1.js"></script>
<script src="${pageContext.request.contextPath}/js/popup.js"></script>

<script>
	function date2str(x, y) {
		var z = {
			M : x.getMonth() + 1,
			d : x.getDate(),
			h : x.getHours(),
			m : x.getMinutes(),
			s : x.getSeconds()
		};
		y = y.replace(/(M+|d+|h+|m+|s+)/g, function(v) {
			return ((v.length > 1 ? "0" : "") + eval('z.' + v.slice(-1)))
					.slice(-2)
		});
		return y.replace(/(y+)/g, function(v) {
			return x.getFullYear().toString().slice(-v.length)
		});
	}

	//聚焦冠字号文本框
	window.onload = function() {
		document.getElementById("dealNo").focus();

	}
	function toUpp() {
		document.getElementById("dealNo").value = document
				.getElementById("dealNo").value.toUpperCase();
	}

	function showInfo() {
		var info = document.getElementById("errorInfo");
		var dealNo = (document.getElementById("dealNo").value).replace(/\s+/g,
				"");
		document.getElementById("dealNo").value = dealNo;
		info.innerHTML = "<font style='color:#999999; font-size:12px;'>请输入完整的冠字号码！冠字号长度为10-12位,可以用‘*’(最多两个*)代替冠字号中的字符</font>";
	}

	function searchResult() {
		var reg = new RegExp("[\\u4E00-\\u9FFF]+", "g");
		var dealNo = (document.getElementById("dealNo").value).replace(/\s+/g,
				"");
		document.getElementById("dealNo").value = dealNo;
		var errInfo = document.getElementById("errorInfo");
		var bannerDiv = document.getElementById("bannerDiv");
		if (dealNo == "") {
			errInfo.innerHTML = "<font style='color:red; font-size:12px;'>冠字号码不能为空，请输入！</font>";
			document.getElementById("dealNo").focus();
			return false;
		} else if ((dealNo.split('*')).length - 1 > 2) {
			errInfo.innerHTML = "<font style='color:red; font-size:12px;'>冠字号码不能包含两个以上的‘*’，请重新输入！</font>";
			document.getElementById("dealNo").focus();
			return false;
		} else if (reg.test(dealNo)) {
			errInfo.innerHTML = "<font style='color:red; font-size:12px;'>冠字号码不能包含汉字’，请重新输入！</font>";
			document.getElementById("dealNo").focus();
			return false;
		} else {
			document.getElementById("FreezeLayer").style.display = "block";
			errInfo.innerHTML = "";
			document.getElementById("search").disabled = true;
			document.getElementById("running").style.display = 'block';
			var login = document.getElementById("login").value;
			$.ajax({
						type : "POST",
						url : "${pageContext.request.contextPath}/GZHQueryServlet?method=queryResult&login="
								+ login,
						data : "dealNo=" + dealNo,
						success : function(data) {
							var resultDiv = document
									.getElementById("searchResult");
							if (data != "notfound") {
								var resultStr = eval(data);
								var contentStr = "";
								var resultStrLength = resultStr.length;
								for (var i = 0; i < resultStr.length; i++) {
									if (resultStr[i].imagepath == undefined) {
										resultStr[i].imagepath = "poka";
									}
									if (resultStr[i].trueflag == "1") {
										resultStr[i].trueflag = "真";
									} else {
										resultStr[i].trueflag = "假";
									}

									if (resultStr[i].pertype == undefined) {
										resultStr[i].pertype = "-";
									}
									if (resultStr[i].pertype == "00") {
										resultStr[i].pertype = "点钞机";
									}
									if (resultStr[i].pertype == "01") {
										resultStr[i].pertype = "ATM";
									}
									if (resultStr[i].pertype == "02") {
										resultStr[i].pertype = "清分机";
									}

									if (resultStr[i].businesstype == "0") {
										resultStr[i].businesstype = "清分";
									}
									if (resultStr[i].businesstype == "1") {
										resultStr[i].businesstype = "存款";
									}
									if (resultStr[i].businesstype == "2") {
										resultStr[i].businesstype = "取款";
									}
									if (resultStr[i].businesstype == "3") {
										resultStr[i].businesstype = "加钞";
									}
									if (resultStr[i].businesstype == "4") {
										resultStr[i].businesstype = "回收";
									}
									if (resultStr[i].businesstype == "5") {
										resultStr[i].businesstype = "清点";
									}

									if (resultStr[i].businesstype == undefined) {
										resultStr[i].businesstype = "-";
									}
									if (resultStr[i].branchname == undefined) {
										resultStr[i].branchname = "-";
									}
									if (resultStr[i].monver == undefined) {
										resultStr[i].monver = "-";
									}
									if (resultStr[i].monval == undefined) {
										resultStr[i].monval = "-";
									}
									if (resultStr[i].bankname == undefined) {
										resultStr[i].bankname = "-";
									}
									if (resultStr[i].bankno == undefined) {
										resultStr[i].bankno = "-";
									}
									if (resultStr[i].montype == "CNY") {
										resultStr[i].montype = "人民币";
									} else {
										resultStr[i].montype = "其它";
									}
									var mon = resultStr[i].mon + "";
									var str = "webapps";
                                    var num = resultStr[i].imagepath.indexOf("webapps");
									contentStr = contentStr
											+ "<tr align='middle'>"
											<%-- 关闭冠字号图片显示功能
											+ "<td width='180px'><div><img  height='20' src='http://10.0.0.132:8080"+resultStr[i].imagepath.substring(num+str.length)+"'></div></td>"
											--%>
											+ "<td width='80px'>"
											+ resultStr[i].mon
											+ "</td>"
											+ "<td width='40px'>"
											+ resultStr[i].monval
											+ "</td>"
											+ "<td width='40px'>"
											+ resultStr[i].monver
											+ "</td>"
											+ "<td width='80px'>"
											+ resultStr[i].operdate
											+ "</td>"
											+ "<td width='80px'>"
											+ resultStr[i].pertype
											+ "</td>"
											+ "<td width='50px'>"
											+ resultStr[i].percode
											+ "</td>"
											+ "<td width='80px'>"
											+ resultStr[i].bankno
											+ "</td>"
											+ "<td width='130px'>"
											+ resultStr[i].bankname
											+ "</td>"
											+ "<td width='80px'>"
											+ resultStr[i].agencyno
											+ "</td>"
											+ "<td width='130px'>"
											+ resultStr[i].branchname
											+ "</td>"
											+ "<td width='100px'>"
											+ resultStr[i].businesstype
											+ "</td>"
											+ "<td width='100px' style='padding-bottom: 8px;'>"
											+ "<div class='theme-buy'><input type='button' class='btn btn-primary' value='点击查看详情' onClick='return getMonDetailInfo(\""
											+ mon
											+ "\");' /></div>"
											+ "</td>" + "</tr>"

								}
								resultDiv.innerHTML = "<div style='border:1px solid #9db3c5;width:90%;height:300px;overflow-x:hidden;overflow-y:scroll' id='contentDiv'><table class='t2'  id='contentValue' style='width:100%'>"
										+ "<thead>"
										<%-- 关闭冠字号图片显示功能
										+ "<th>冠字号码图片</th>"
										--%>
										+ "<th>冠字号码</th>"
										+ "<th>币值</th>"
										+ "<th>版别</th>"
										+ "<th>日期</th>"
										+ "<th>设备类型</th>"
										+ "<th>设备编号</th>"
										+ "<th>银行编号</th>"
										+ "<th>银行名称</th>"
										+ "<th>网点编号</th>"
										+ "<th>网点名称</th>"
										+ "<th>业务类型</th>"
										+ "<th>详情</th>"
										+ "</thead>"
										+ contentStr
										+ "<tr>"
										+ "<td colspan='13' align='center'>"
										+ "</td>" + "</tr>" + "<table></div>";
								var table = document
										.getElementById("contentValue");//根据table的 id 属性值获得对象    
								var rows = table.getElementsByTagName("tr");//获取table类型的tr元素的列表  
								for (var i = 0; i < rows.length; i++) {
									if (i % 2 == 0) {
										rows[i].style.backgroundColor = "#e8f3fd";//偶数行时背景色为#e8f3fd  
									} else {
										rows[i].style.backgroundColor = "White";//单数行时背景色为white  
									}
								}
								resultDiv.style.display = 'block';
								document.getElementById("search").disabled = false;
								document.getElementById("FreezeLayer").style.display = "none";
								document.getElementById("running").style.display = 'none';

								var contentDiv = document
										.getElementById("contentDiv");
								var form = document.getElementById("form");
								if (resultStrLength > 130) {
									contentDiv.style.height = "550px";
									bannerDiv.style.height = "800px";
									form.style.cssText = "padding-top: 50px;"
								}
								if (resultStrLength < 130) {
									contentDiv.style.height = "300px";
									bannerDiv.style.height = "550px";
									form.style.cssText = "padding-top: 50px;"
								}
								errInfo.innerHTML = "<div style='text-align:center'><font style='color:#999999; font-size:13px;'>系统帮您查找到</font>"
										+ "<font style='color:#0000FF; font-size:20px;'>"
										+ resultStrLength
										+ "</font>"
										+ "<font style='color:#999999; font-size:13px;'>条相关记录</font></div>";
							} else {
								document.getElementById("FreezeLayer").style.display = "none";
								bannerDiv.style.height = "550px";
								resultDiv.innerHTML = "<font style='color:#0000FF; font-size:25px;'>对不起，您要查找的冠字号码不存在！</font>";
								resultDiv.style.display = 'block';
								document.getElementById("search").disabled = false;
								document.getElementById("running").style.display = 'none';
							}
						}
					});
		}
		
		
	}
	
	$(document).keyup(function(event) {
		if (event.keyCode == 13) {
			searchResult();
			document.getElementById("dealNo").blur();
		}
	});
	
	/**
	 * 2017年10月18日
	 * 点开弹窗
	 * @param dealNo
	 */
	function getMonDetailInfo(dealNo){
		getPopupInfo(dealNo);
		$('.theme-popover-mask').fadeIn(100);
		$('.theme-popover').slideDown(200);
	}

	/**
	 * 点击按钮关闭弹窗
	 */
	function closeWindows(){
		$('.theme-popover-mask').fadeOut(100);
		$('.theme-popover').slideUp(200);
	}

	/**
	 * 2017年10月18日
	 * 补充弹窗的详细信息
	 * @param dealNo
	 */
	function getPopupInfo(dealNo){
		$.ajax({
			type : "GET",
			url : "${pageContext.request.contextPath}/PopupServlet",
			data : "dealNo=" + dealNo,
			success : function(data) {
				if (data != "notfound") {
					//获取html语言需要插入的div地址
					var resultDiv = document
					.getElementById("popup");
					//获取后台返回值
					var resultStr = eval(data);
					//用于存放准备拼接的Html弹窗
					var contentStr = "";
					//遍历返回值list
					var resultStrLength = resultStr.length;
					for (var i = 0; i < resultStr.length; i++) {
						if (resultStr[i].operdate == undefined) {
							resultStr[i].operdate = "-";
						}
						if (resultStr[i].opertype == undefined) {
							resultStr[i].opertype = "-";
						}
						if (resultStr[i].operator == undefined) {
							resultStr[i].operator = "-";
						}
						if (resultStr[i].checker == undefined) {
							resultStr[i].checker = "-";
						}
						if (resultStr[i].memo == undefined) {
							resultStr[i].memo = "-";
						}
						//弹窗表体
						var j = i+1;
						contentStr = contentStr
								+ "<tr align='center' style='height: 20px; border: 1px solid #cad9ea'>" 
								+ "<td style='border: 1px solid #cad9ea'>" 
								+ j 
								+ "</td>" 
								+ "<td style='border: 1px solid #cad9ea'>" 
								+ resultStr[i].operdate
								+ "</td>" 
								+ "<td style='border: 1px solid #cad9ea'>" 
								+ resultStr[i].opertype 
								+ "</td>" 
								+ "<td style='border: 1px solid #cad9ea'>" 
								+ resultStr[i].operator 
								+ "</td>" 
								+ "<td style='border: 1px solid #cad9ea'>" 
								+ resultStr[i].checker
								+ "</td>" 
								+ "<td style='border: 1px solid #cad9ea; text-align: left; padding: 3px'>" 
								+ resultStr[i].memo 
								+ "</td></tr>";

					}
					//弹窗整合
					resultDiv.innerHTML = "<table style='border: 1px solid #cad9ea;'>"
						+ "<tr height='35px'>"
						+ "<th style='width: 80px; border: 1px solid #cad9ea'>序号</th>" 
						+ "<th style='width: 400px; border: 1px solid #cad9ea'>时间</th>"
						+ "<th style='width: 180px; border: 1px solid #cad9ea'>业务类型</th>" 
						+ "<th style='width: 180px; border: 1px solid #cad9ea'>操作员</th>" 
						+ "<th style='width: 180px; border: 1px solid #cad9ea'>复核员</th>" 
						+ "<th style='width: 550px; border: 1px solid #cad9ea'>详情</th>" 
						+ "</tr>" 
						+ contentStr
						+ "</table>";
					
				} else {
					var resultDiv = document
					.getElementById("popup");
					resultDiv.innerHTML = "<h1>未找到详细信息</h1>";
				}
			}
		});
	}
</script>
</head>

<body>
	<input type="hidden" value=${login } id="login" name="login" />
	<div
		style="border: 1px solid graytext; background: url('${pageContext.request.contextPath}/style/blue/images/banner.jpg') repeat-x ; height: 550px;"
		id="bannerDiv">
		<div style="padding-top: 15px;">
			<h1>
				<font size="6" color="#FFFFFF" face="微软雅黑">&nbsp;POKA&nbsp;</font><font
					size="4" color="#FFFFFF" face="华文楷体">人民币冠字号码查询信息管理系统欢迎您</font>
			</h1>
		</div>

		<form action="" id="form" name="form" method="post"
			style="padding-top: 230px;">
			<div style='width: 100%' align="center">
				<table style="height: 70px;" align="center" cellpadding="0">
					<tr>
						<td
							style="text-overflow: ellipsis; word-break: keep-all; white-space: nowrap; height: 30px;">
							<font size="4"><b>请输入冠字号码：</b></font>&nbsp; <input type="text"
							id="dealNo" name="dealNo" maxlength="12"
							style="border: 1px solid rgb(115, 155, 192); background: transparent; height: 30px;"
							onblur="showInfo();toUpp();" size="30">&nbsp;
						</td>
						<td width="35px">
							<div id="running" style="display: none;">
								<img
									src="${pageContext.request.contextPath}/style/blue/images/loading.gif"></img>
							</div>
						</td>
						<td><input type="button" id="search" class="btn26" value="查询"
							onClick="return searchResult();" /></td>
						<td><input type="text" style="display: none" id="searchCount"
							name="searchCount"></td>
					</tr>
					<tr>
						<td>
							<div id="errorInfo"
								style="width: 280px; height: 40px; float: right;"></div>
						</td>
					</tr>
				</table>
			</div>
		</form>
		<h3></h3>
		<div id="searchResult"
			style="overflow: auto; width: auto; height: auto; display: none; margin-left: 5px; margin-right: 5px"
			align="center"></div>
	</div>
	<br />
	<div align="center">
		<hr style="border: 1px dashed; border-bottom: 1px solid graytext;">
		<span style="color: #999999; font-family: '宋体'; font-size: 13;">系统提供商:深圳宝嘉电子设备有限公司
			(V3.0) <br /> Copyright (c) www.poka.com.cn All rigths reserved.
		</span>
	</div>
	<div id="FreezeLayer" class="freezeLayer"
		style="height: 100%; width: 100%; display: none;">
		<div id='loading' class='loading'>数据加载中...</div>
	</div>

	<%--
		2017年10月16日 冠字号详情
	 --%>
	<div class="theme-popover" style="display: none;">
		<div class="theme-poptit">
			<a href="javascript:;" title="关闭" class="close">×</a>
			<h3>详细信息</h3>
		</div>
		<div class="theme-popbod dform"
			style="padding-top: 10px; overflow: auto" id="popup">
		</div>
		<div style="text-align: center; margin: 20px">
			<input class="btn btn-primary close" value=" 关闭 " type="button"
				onClick='return closeWindows()' style="font-size: 18px">
		</div>
	</div>
</body>
</html>
