package com.deCampredon.flexAcacia.validation.test
{
	import com.deCampredon.flexAcacia.validation.test.core.ValidationModelTest;
	import com.deCampredon.flexAcacia.validation.test.core.ValidationSessionTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class ValidationCoreTestSuite
	{
		public var validationModelTest:ValidationModelTest;
		public var validationSessionTest:ValidationSessionTest;
	}
}