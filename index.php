<?php
//此为示例PHP，可以修改为与您的数据库链接或者您也可以手动修改
//

$List = 
    array(
		"motd"=>"你好，欢迎来到我的源，这是在你使用我的源之后要注意的事项：\n1.本源会...", //当别人切换到你的源时，会显示的一条公告
        "motd_time"=>"10", //切换到你的源之后，要显示多少秒的公告，根据公告的字数酌情调整
		array(
            "name"=>"游戏1",
            "preview"=>"https://static.launchersu.net/custom_game.png",
            "processName"=>"game.exe",
            "gameid"=>"游戏的Steam AppID，选填,不需要请留空",
            "list"=> array(
				array(
					"name"=>"显示的名字",
					"descript"=>"描述",
					"lastupd"=>"最后更新日期",
					"dlurl"=>"下载链接",
					"disabled"=>"是否禁止加载,填写0或者1",
					"compressed"=>"指示dll是否被zlib压缩,填写0或者1",
					"MD5"=>"dll的MD5,用于下载校验,选填,不需要请留空"
				),
				array(
					"name"=>"My Cheat",
					"descript"=>"F1 - ESP\nF2 - AimBot\nF3 - Glow",
					"lastupd"=>"2022-1-1 00:00:00",
					"dlurl"=>"http://mydomain.com/MyCheat.dll",
					"disabled"=>"0",
					"compressed"=>"0",
					"MD5"=>""
				)
			)
        ),
        array(
            "name"=>"csgo",
            "preview"=>"https://static.launchersu.net/custom_game.png",
            "processName"=>"csgo.exe",
            "gameid"=>"730",
            "list"=> array(
				array(
					"name"=>"Glow Internal",
					"descirpt"=>"F1 - Glow\nF2 - AimBot",
					"lastupd"=>"2022-1-1 00:00:00",
					"dlurl"=>"http://mydomain.com/GlowInternal.dll",
					"disabled"=>"0",
					"compressed"=>"0",
					"MD5"=>""
				)
			)
        )
    );

exit(json_encode($List, TRUE));
	
?>