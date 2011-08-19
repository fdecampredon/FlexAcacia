/*
* Copyright 2009 François de Campredon
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

package com.deCampredon.flexAcacia.validation.core
{
	import com.deCampredon.flexAcacia.validation.constraints.SubValidationTarget;

	
	/**
	 ** the ValidatorDefinition Class contains list of constraint for a validation target.
	 * It can be created using the ValidatorDefinitionFactory (for metadata based constraint definition)
	 * Or using MXML by populating the constraints array property.
	 * the ValidatorDefinition Class allow the creation of <code>ValidationSession</code>.
	 *  
	 * @author François de Campredon
	 */	
	[DefaultProperty("constraints")]
	public class ValidationModel 
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 * @param constraints array of Constraint
		 */
		public function ValidationModel(contraints:Array = null) {
			this.constraints = contraints;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		
		//----------------------------------
		//  constraints
		//----------------------------------
		
		
		[ArrayElementType("com.deCampredon.flexAcacia.validation.core.Constraint")]
		/**
		 * List of <code>Constraint</code>
		 */
		public var constraints:Array;
		
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Create a new <code>ValidationSession</code>, select all <code>Constraint</code> of the <code>ValidatorDefinition</code>
		 * if params <code>fields</code> and <code>groups</code> are null, select the corresponding subset of <code>Constraint</code>
		 * otherwise.
		 * 
		 * @param target the validation target of the created <code>ValidationSession</code>
		 * 
		 * @param fields by passing a list of field name you can select a subset of <code>Constraint</code> 
		 * for the created <code>ValidationSession</code>
		 * 
		 * @param groups by passing a list of group name you can select a subset of <code>Constraint</code> 
		 * for the created <code>ValidationSession</code>
		 */
		public function newValidationSession(target:Object,fields:Array=null,groups:Array=null):ValidationSession {
			
			var selectedConstraints:Array = [];
			if(!fields && !groups) {
				selectedConstraints =  cloneConstraint();
			}
			else if(fields!=null){
				for each(var field:String in fields) {
					selectedConstraints = selectedConstraints.concat(getConstraintsForField(field));
				}
			}
			return new ValidationSession(target,selectedConstraints);
		}
		
		/**
		 * return constraint attached to a given field
		 * @params field the field 
		 */
		public function getConstraintsForField(field:String):Array {
			var fieldSplit:Array = field.split(".",2);
			var constraint:Constraint;
			var result:Array = [];
			if(fieldSplit.length ==1) {
				for each(constraint in constraints) {
					if(constraint.field == field)
						result.push(constraint.clone());
				}
			}
			else {
				var baseField:String = fieldSplit[0];
				var subField:String = fieldSplit[1];
				var subConstraint:Constraint;
				var subValidationModel:ValidationModel;
				for each(constraint in constraints) {
					if(constraint.field == baseField && constraint is SubValidationTarget) {
						subValidationModel = (constraint as SubValidationTarget).validationModel;
						result = subValidationModel.getConstraintsForField(subField);
						for each(subConstraint in result) {
							subConstraint.field = baseField+"."+subConstraint.field;
						}
						break;
					}
				}
			}
			return result;
		}
		
		
		public function getConstraintsForGroup(group:String):Array {
			var constraint:Constraint,subConstraint:Constraint;
			var result:Array = [];
			for each(constraint in constraints) {
				if(constraint is SubValidationTarget) {
					var subResult:Array = SubValidationTarget(constraint).validationModel.getConstraintsForGroup(group);
					for each(subConstraint in subResult) {
						subConstraint.field = constraint.field+"."+subConstraint.field;
					}
					result = result.concat(subResult);
				}
				if(constraint.groups && constraint.groups.indexOf(group)!=-1) {
					result.push(constraint.clone());
				}
			}
			return result;
		}
		
		/**
		 * return a clone of the current <code>ValidatorDefinition</code>
		 */
		public function clone():ValidationModel {
			return new ValidationModel(cloneConstraint())
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		
		
		/**
		 * @private
		 */
		private function cloneConstraint():Array {
			var clonedConstraints:Array = [];
			for each(var constraint:Constraint in constraints) {
				clonedConstraints.push(constraint.clone());
			}
			return clonedConstraints;
		}
		
		
	}
}