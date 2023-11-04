<?php
	class Model_Software extends RedBean_SimpleModel{
		public function setSoftware($vendor, $name){
			$this->softvendor = $vendor;
			$this->softname = $name;
		}
		public function getVendor(){
			return $this->softvendor;
		}
		public function getName(){
			return $this->softname;
		}
	}
?>