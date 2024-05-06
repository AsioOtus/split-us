import ComposableArchitecture
import HintListComponent
import DLServices
import DLUtils

extension Registration {
	@ObservableState
	public struct State: Equatable {
		public var email = ""
		public var username = ""
		public var name = ""
		public var password = ""
		public var passwordRepeat = ""
		
		public var registrationRequest: Loadable<Never> = .initial()
		public var submitErrorTrigger = 1
		
		public var validation: Validation = .init()
		
		public var isUsernameHintRequired = false
		public var isPasswordHintRequired = false
		
		var isPasswordsEqual: Bool {
			password == passwordRepeat
		}
		
		var shouldShowPasswordsMismatch: Bool {
			validation.isPasswordEqualityCheckRequired && !isPasswordsEqual
		}
		
		public init () { }
	}
}

extension Registration.State {
	var usernameHintsState: HintList.State {
		.init(
			title: .registrationUsernameHintTitle,
			hints: [
				.init(
					id: "1",
					text: .registrationUsernameHintPointLength,
					iconName: iconName(
						"ruler",
						validation
							.usernameMismatches
							.hintAppearance(
								[.tooShort, .tooLong, .empty],
								isWarning: validation.isUsernameResultRequired,
								isValidationEnabled: validation.isStrictValidationMode
							)
					),
					appearance: validation
						.usernameMismatches
						.hintAppearance(
							[.tooShort, .tooLong, .empty],
							isWarning: validation.isUsernameResultRequired,
							isValidationEnabled: validation.isStrictValidationMode
						)
				),
				.init(
					id: "2",
					text: .registrationUsernameHintPointContent,
					iconName: "textformat",
					appearance: validation
						.usernameMismatches
						.hintAppearance(
							[.containsProhibitedSymbols, .empty],
							isWarning: validation.isUsernameResultRequired,
							isValidationEnabled: validation.isStrictValidationMode
						)
				),
			]
		)
	}
	
	var passwordHintsState: HintList.State {
		.init(
			title: .registrationPasswordHintIntro,
			hints: [
				.init(
					id: "1",
					text: .registrationPasswordHintPointLength,
					iconName: iconName(
						"ruler",
						validation
							.passwordMismatches
							.hintAppearance(
								[.tooShort, .empty],
								isWarning: validation.isPasswordResultRequired,
								isValidationEnabled: validation.isStrictValidationMode
							)
					),
					appearance: validation
						.passwordMismatches
						.hintAppearance(
							[.tooShort, .empty],
							isWarning: validation.isPasswordResultRequired,
							isValidationEnabled: validation.isStrictValidationMode
						)
				),
				.init(
					id: "2",
					text: .registrationPasswordHintPointDigits,
					iconName: iconName(
						"123.rectangle",
						validation
							.passwordMismatches
							.hintAppearance(
								[.withoutDigits, .empty],
								isWarning: validation.isPasswordResultRequired,
								isValidationEnabled: validation.isStrictValidationMode
							)
					),
					appearance: validation
						.passwordMismatches
						.hintAppearance(
							[.withoutDigits, .empty],
							isWarning: validation.isPasswordResultRequired,
							isValidationEnabled: validation.isStrictValidationMode
						)
				),
				.init(
					id: "3",
					text: .registrationPasswordHintPointNonLowerCaseCharacter,
					iconName: iconName(
						"at.circle",
						validation
							.passwordMismatches
							.hintAppearance(
								[.withoutNonLowerCased, .empty],
								isWarning: validation.isPasswordResultRequired,
								isValidationEnabled: validation.isStrictValidationMode
							)
					),
					appearance: validation
						.passwordMismatches
						.hintAppearance(
							[.withoutNonLowerCased, .empty],
							isWarning: validation.isPasswordResultRequired,
							isValidationEnabled: validation.isStrictValidationMode
						)
				)
			]
		)
	}
	
	private func iconName (_ iconName: String, _ appearance: HintList.Appearance) -> String {
		switch appearance {
		case .completed: iconName + ".fill"
		case .uncompleted, .warning, .invalid: iconName
		}
	}
}

fileprivate extension OptionSet {
	func hintAppearance (
		_ optionSet: Self,
		isWarning: Bool,
		isValidationEnabled: Bool
	) -> HintList.Appearance {
		self.isDisjoint(with: optionSet)
		? .completed
		: isValidationEnabled
		? .invalid
		: isWarning
		? .warning
		: .uncompleted
	}
}

extension Registration.State {
	public struct Validation: Equatable {
		var isStrictValidationMode = false
		
		var isEmailResultRequired = false
		var emailMismatches = EmailValidationService.Mismatch()
		
		var isUsernameResultRequired = false
		var usernameMismatches = UsernameValidationService.Mismatch()
		
		var isPasswordResultRequired = false
		var passwordMismatches = PasswordValidationService.Mismatch()
		
		var isPasswordEqualityCheckRequired = false
		
		var isValid: Bool {
			emailMismatches == [] && usernameMismatches == []
		}
		
		var shouldShowEmailMismatch: Bool {
			isStrictValidationMode && isEmailResultRequired && !emailMismatches.isEmpty
		}
		
		var shouldShowUsernameMismatch: Bool {
			isStrictValidationMode && isUsernameResultRequired && !usernameMismatches.isEmpty
		}
		
		var shouldShowPasswordMismatch: Bool {
			isStrictValidationMode && isPasswordResultRequired && !passwordMismatches.isEmpty
		}
	}
}
