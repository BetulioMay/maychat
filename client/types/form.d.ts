export interface RegisterFormValues {
  username: string;
  email: string;
  password: string;
  passwordConfirmation: string;
}
export interface RegisterErrorValues {
  username: string;
  email: string;
  password: string;
  passwordConfirmation: string;
}
export interface LoginFormValues {
  usernameOrEmail: string;
  password: string;
}
export interface LoginErrorValues {
  usernameOrEmail: string;
  password: string;
}
