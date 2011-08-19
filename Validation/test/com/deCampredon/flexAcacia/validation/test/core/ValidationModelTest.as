package com.deCampredon.flexAcacia.validation.test.core
{
	import com.deCampredon.flexAcacia.validation.constraints.SubValidationTarget;
	import com.deCampredon.flexAcacia.validation.core.Constraint;
	import com.deCampredon.flexAcacia.validation.core.ValidationModel;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertEquals;

	public class ValidationModelTest
	{
		public var validationModel:ValidationModel;
		
		[Before]
		public function setUp():void {
			var subValidationTarget:SubValidationTarget;
			subValidationTarget = new SubValidationTarget();
			subValidationTarget.field = "subValidationTarget";
			subValidationTarget.validationModel = new ValidationModel([new MockConstraint("subConstraint","subField",["group2"])]);
			
			validationModel  = new ValidationModel([
				new MockConstraint("constraint1","field1",['group1']),
				new MockConstraint("constraint2","field2",['group1','group2']),
				new MockConstraint("constraint3","field2",null),
				subValidationTarget
			]);
		}
		
		
		[Test]
		public function extractOneConstraintForField():void {
			var result:Array = validationModel.getConstraintsForField("field1");
			assertEquals(result.length,1);
			assertEquals(result[0].id,"constraint1");
			assertEquals(result[0].field,"field1");
		}
		
		[Test]
		public function extractMultipleConstraintForField():void {
			var result:Array = validationModel.getConstraintsForField("field2");
			assertEquals(result.length,2);
			assertEquals(result[0].id,"constraint2");
			assertEquals(result[0].field,"field2");
			assertEquals(result[1].id,"constraint3");
			assertEquals(result[1].field,"field2");
		}
		
		[Test]
		public function extractSubField():void {
			var result:Array = validationModel.getConstraintsForField("subValidationTarget.subField");
			assertEquals(result.length,1);
			assertEquals(result[0].id,"subConstraint");
			assertEquals(result[0].field,"subValidationTarget.subField");
		}
		
		[Test]
		public function extractSimpleGroup():void {
			var result:Array = validationModel.getConstraintsForGroup("group1");
			assertEquals(result.length,2);
			assertEquals(result[0].id,"constraint1");
			assertEquals(result[0].field,"field1");
			assertEquals(result[1].id,"constraint2");
			assertEquals(result[1].field,"field2");
		}
		
		[Test]
		public function extractComplexGroup():void {
			var result:Array = validationModel.getConstraintsForGroup("group2");
			assertEquals(result.length,2);
			assertEquals(result[0].id,"constraint2");
			assertEquals(result[0].field,"field2");
			assertEquals(result[1].id,"subConstraint");
			assertEquals(result[1].field,"subValidationTarget.subField");
		}
	}
}