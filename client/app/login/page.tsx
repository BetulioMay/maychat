// import dynamic from "next/dynamic";
import LoginForm from "components/forms/LoginForm";

// const LoginForm = dynamic(() => import("components/forms/LoginForm"), {
//   ssr: false,
// });

export default function LoginPage() {
  return <LoginForm />;
}
