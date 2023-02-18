import dynamic from "next/dynamic";

const LoginForm = dynamic(() => import("components/forms/LoginForm"), {
  ssr: false,
});

export default function LoginPage() {
  return <LoginForm />;
}
