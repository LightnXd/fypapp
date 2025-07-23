Overview
The FYP App is designed for two primary user roles: Contributors and Organizations, focusing on charity promotion, donation transparency, and community interaction. It integrates blockchain for verifiable transactions and Stripe for secure payments.

Instalation:
To install this app you can clone this project and do
> flutter pub get

To get the dependencies
You can run this project from the lib/main.dart
When running the app if the loading on launching is not resolved after a while that could mean the server is not hosted anymore, to address this issues you can clone the server from https://github.com/LightnXd/fyp_backend 
Then launch the server in local or location of your choosing and then update the baseUrl on lib/service/Url.dart to ther server location

Folder Structure
Main Entry Points
These are the core entry and session handling files:
•	main.dart – Application entry point and routing configuration.
•	open_page.dart – Checks user session and determines user role (Contributor or Organization).
•	login_page.dart – UI for user login via email/password.
•	reset_password.dart – Functionality for password recovery/reset.

Organization Module (organization/)
Organization-specific features and screens.
Authentication & Profile
•	register.dart – Organization registration with OTP verification.
•	profile.dart – Manage organization details and integrate Stripe account.
•	home.dart – Dashboard view for organizations to manage posts, proposals, and followers.
•	main_page.dart – Navigation wrapper for organization-specific pages.
Content Management
•	create_post.dart – Create and upload media-rich posts for visibility.
•	create_proposal.dart – Submit proposals for funding.
•	confirm_proposal.dart – Workflow for reviewing and confirming submitted proposals.
Community Management
•	follower_list.dart – View the list of users following the organization.
•	follower_details.dart – Inspect individual follower profiles and interactions.
Transparency Tools
•	transparency_test.dart – Self-assessment tool based on charity transparency framework.

Contributor Module (contributor/)
Contributor-specific features for interaction and support.
Authentication & Profile
•	register.dart – Registration flow including date picker for age verification.
•	profile.dart – Manage user profile information.
•	home.dart – Contributor feed with dynamic content and organization posts.
•	main_page.dart – Bottom navigation container for contributors.
Discovery & Following
•	followed_list.dart – List of organizations the contributor follows.
•	organization_details.dart – View detailed profile of an organization.
•	recomendation.dart – Algorithmic suggestions for new organizations to follow.
Proposals & Voting
•	proposal_list.dart – View all active proposals.
•	proposal_details.dart – View details and vote on individual proposals.
•	proposal_history.dart – Access record of past proposals voted on.
Donations & Transparency
•	make_donation.dart – Stripe payment integration for contributing to causes.
•	ledger_list.dart – View blockchain ledger with transaction records.
•	ledger_details.dart – Inspect a specific ledger entry.
•	verify_ledger.dart – Cross-check ledger integrity using hashing and blockchain logic.

Services Layer (services/)
Business logic and integration services.
Authentication & Profile
•	authentication.dart – Handles login, registration, token/session logic.
•	profile.dart – CRUD operations for user and organization profiles.
•	follow.dart – Backend logic for follow/unfollow interactions.
Content & Communication
•	posting.dart – Manages post creation and retrieval from backend.
•	image_upload.dart – Handles media uploads (e.g., image picker, cloud storage).
Blockchain & Transparency
•	transaction.dart – Blockchain logic for creating, appending, and verifying blocks.
•	charity_transparency_framework_question.dart – Data model for transparency framework questions.
Utilities
•	url.dart – Central API and endpoint configuration.
•	date_converter.dart – Utility for parsing and formatting dates.

Widget Components (widget/)
Reusable UI components for layout and functionality.
Navigation & Layout
•	app_bar.dart – Custom top app bar with actions.
•	navigation_bar.dart – Bottom tab navigation.
•	side_bar.dart – Drawer for additional navigation options.
Forms & Input
•	question_box.dart – Reusable input field widget for forms.
•	date_picker.dart – Date selection widget.
•	checkbox.dart – Custom checkbox UI.
•	dropdown_label.dart – Dropdown component with label.
Content Display
•	post_view.dart – Display post cards with images and content.
•	proposal_information.dart – Proposal preview cards.
•	ledger_list.dart – List view of blockchain transactions.
•	dynamic_image_view.dart – Zoomable image gallery view.
•	avatar_box.dart – Profile avatar display widget.
UI Elements
•	response_dialog.dart – Displays success, error, and confirmation dialogs.
•	otp_confirmation.dart – OTP input modal for verification.
•	empty_box.dart – For spacing or showing empty state.
•	icon_box.dart – Icon with label display for quick info.
•	horizontal_box.dart – Horizontal scroll content row.
•	profile_head.dart – User or org profile header with name and image.

Key Features: 
Authentication Flow
•	OTP-based email registration.
•	Role-based login redirection (organization/contributor).
•	Password reset via email.
Organization Features
•	Organization-type selection during signup (NGO, Charity, etc.)
•	Proposal and post creation.
•	Stripe onboarding and integration.
•	Transparency self-assessment.
•	Follower management.
Contributor Features
•	Follow and view organization content.
•	Vote on and comment on proposals.
•	Secure donations via Stripe.
•	View and verify ledger of donations.
Blockchain Integration
•	All donation transactions are written to a blockchain ledger.
•	Each transaction is hash-verified.
•	Full ledger can be exported to Excel.
•	Transparency verification via hashing logic.
Technical Architecture
•	Modular architecture with clear separation of concerns.
•	Reusable components reduce code duplication.
•	Supabase backend for user, post, and proposal management.
•	Stripe integration for secure payments.
•	Real-time data using Supabase streaming.

