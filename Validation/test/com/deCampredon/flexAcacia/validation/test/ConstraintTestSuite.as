package com.deCampredon.flexAcacia.validation.test
{
	import com.deCampredon.flexAcacia.validation.test.constraint.AssertConstraintTest;
	import com.deCampredon.flexAcacia.validation.test.constraint.EmailConstraintTest;
	import com.deCampredon.flexAcacia.validation.test.constraint.FutureConstraintTest;
	import com.deCampredon.flexAcacia.validation.test.constraint.MaxConstraintTest;
	import com.deCampredon.flexAcacia.validation.test.constraint.MinConstraintTest;
	import com.deCampredon.flexAcacia.validation.test.constraint.NotNullConstraintTest;
	import com.deCampredon.flexAcacia.validation.test.constraint.PastConstraintTest;
	import com.deCampredon.flexAcacia.validation.test.constraint.PatternConstraintTest;
	import com.deCampredon.flexAcacia.validation.test.constraint.SizeConstraintTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class ConstraintTestSuite
	{
		public var assertConstraintTest:AssertConstraintTest;
		public var emailConstraintTest:EmailConstraintTest;
		public var futureConstraintTest:FutureConstraintTest;
		public var maxConstraintTest:MaxConstraintTest;
		public var minConstraintTest:MinConstraintTest;
		public var notNullConstraintTest:NotNullConstraintTest;
		public var pastConstraintTest:PastConstraintTest;
		public var patternConstraintTest:PatternConstraintTest;
		public var sizeConstraintTest:SizeConstraintTest;
	}
}